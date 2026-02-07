#!/usr/bin/env bash
# statistics.sh - 복수 평가 통계 계산
#
# 목적: 3회 측정 점수로부터 평균, 표준편차, 95% 신뢰구간 계산
#       신뢰구간 분리 여부로 유의미한 향상 판단

set -euo pipefail

# ------------------------------------------------------------------------------
# 평균 계산 (Mean)
# ------------------------------------------------------------------------------
# Usage: calc_mean score1 score2 score3 ...
# Example: calc_mean 82 85 79
# Output: 82.0
calc_mean() {
    local sum=0
    local count=$#

    if [[ $count -eq 0 ]]; then
        echo "0"
        return 1
    fi

    for score in "$@"; do
        sum=$(echo "$sum + $score" | bc -l)
    done

    echo "scale=2; $sum / $count" | bc -l
}

# ------------------------------------------------------------------------------
# 표준편차 계산 (Standard Deviation)
# ------------------------------------------------------------------------------
# Usage: calc_stddev mean score1 score2 score3 ...
# Example: calc_stddev 82 82 85 79
# Output: 3.0
calc_stddev() {
    local mean=$1
    shift
    local count=$#

    if [[ $count -le 1 ]]; then
        echo "0"
        return 0
    fi

    local sum_sq_diff=0
    for score in "$@"; do
        local diff
        diff=$(echo "$score - $mean" | bc -l)
        local sq_diff
        sq_diff=$(echo "$diff * $diff" | bc -l)
        sum_sq_diff=$(echo "$sum_sq_diff + $sq_diff" | bc -l)
    done

    # 표본 표준편차 (n-1로 나눔)
    echo "scale=2; sqrt($sum_sq_diff / ($count - 1))" | bc -l
}

# ------------------------------------------------------------------------------
# 95% 신뢰구간 계산 (Confidence Interval)
# ------------------------------------------------------------------------------
# Usage: calc_ci mean stddev sample_size
# Example: calc_ci 82 3.0 3
# Output: 76.5 87.5
calc_ci() {
    local mean=$1
    local stddev=$2
    local n=$3

    # t-분포 임계값 (95% 신뢰구간)
    # n=3일 때 df=2, t_0.025,2 = 4.303
    # n=4일 때 df=3, t_0.025,3 = 3.182
    # n=5일 때 df=4, t_0.025,4 = 2.776
    local t_value
    case $n in
        2) t_value=12.706 ;;
        3) t_value=4.303 ;;
        4) t_value=3.182 ;;
        5) t_value=2.776 ;;
        *) t_value=2.0 ;; # 근사치 (n>30이면 z-분포 사용)
    esac

    # 표준오차 (Standard Error)
    local se
    se=$(echo "scale=4; $stddev / sqrt($n)" | bc -l)

    # 오차 범위 (Margin of Error)
    local margin
    margin=$(echo "scale=2; $t_value * $se" | bc -l)

    # 신뢰구간 [lower, upper]
    local lower
    lower=$(echo "scale=2; $mean - $margin" | bc -l)
    local upper
    upper=$(echo "scale=2; $mean + $margin" | bc -l)

    echo "$lower $upper"
}

# ------------------------------------------------------------------------------
# 샘플 사이즈 헬퍼 함수 (신규 추가)
# ------------------------------------------------------------------------------

# 권장 샘플 사이즈 반환
# Usage: get_recommended_sample_size [precision_level]
# precision_level: "standard" (n=3) | "high" (n=5)
# Output: integer
get_recommended_sample_size() {
    local precision="${1:-standard}"

    case "$precision" in
        high|precise|5)
            echo 5
            ;;
        standard|normal|3|*)
            echo 3
            ;;
    esac
}

# 샘플 사이즈별 신뢰구간 폭 예상 (검정력 안내용)
# Usage: estimate_ci_width stddev sample_size
# Output: estimated CI width
estimate_ci_width() {
    local stddev=$1
    local n=$2

    local t_value
    case $n in
        3) t_value=4.303 ;;
        5) t_value=2.776 ;;
        *) t_value=2.0 ;;
    esac

    local se
    se=$(echo "scale=4; $stddev / sqrt($n)" | bc -l)
    local width
    width=$(echo "scale=2; 2 * $t_value * $se" | bc -l)

    echo "$width"
}

# ------------------------------------------------------------------------------
# 신뢰구간 분리 판단 (CI Separation Check)
# ------------------------------------------------------------------------------
# Usage: ci_separated prev_ci_upper curr_ci_lower
# Example: ci_separated 87.5 88.0
# Returns: 0 (true) if separated, 1 (false) otherwise
ci_separated() {
    local prev_upper=$1
    local curr_lower=$2

    # 이전 CI 상한 < 현재 CI 하한 → 유의미한 향상
    if (( $(echo "$prev_upper < $curr_lower" | bc -l) )); then
        return 0  # true
    else
        return 1  # false
    fi
}

# ------------------------------------------------------------------------------
# 베이스라인 JSON 생성
# ------------------------------------------------------------------------------
# Usage: generate_baseline_json score1 score2 score3 ...
# Output: JSON string
generate_baseline_json() {
    local scores=("$@")
    local scores_json
    scores_json=$(printf '%s,' "${scores[@]}" | sed 's/,$//')

    local mean
    mean=$(calc_mean "${scores[@]}")
    local stddev
    stddev=$(calc_stddev "$mean" "${scores[@]}")
    local n=${#scores[@]}
    local ci
    mapfile -t ci < <(calc_ci "$mean" "$stddev" "$n")

    cat <<EOF
{
  "scores": [$scores_json],
  "mean": $mean,
  "stddev": $stddev,
  "ci": [${ci[0]}, ${ci[1]}],
  "sample_size": $n,
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
}

# ------------------------------------------------------------------------------
# 향상 비교 리포트 생성
# ------------------------------------------------------------------------------
# Usage: generate_improvement_report prev_json curr_json
# Output: Human-readable comparison report
generate_improvement_report() {
    local prev_json=$1
    local curr_json=$2

    # JSON 파싱 (jq 필요)
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required for JSON parsing" >&2
        return 1
    fi

    local prev_mean
    prev_mean=$(echo "$prev_json" | jq -r '.mean')
    local prev_ci_lower
    prev_ci_lower=$(echo "$prev_json" | jq -r '.ci[0]')
    local prev_ci_upper
    prev_ci_upper=$(echo "$prev_json" | jq -r '.ci[1]')

    local curr_mean
    curr_mean=$(echo "$curr_json" | jq -r '.mean')
    local curr_ci_lower
    curr_ci_lower=$(echo "$curr_json" | jq -r '.ci[0]')
    local curr_ci_upper
    curr_ci_upper=$(echo "$curr_json" | jq -r '.ci[1]')

    local delta
    delta=$(echo "scale=2; $curr_mean - $prev_mean" | bc -l)
    local delta_pct
    delta_pct=$(echo "scale=2; ($delta / $prev_mean) * 100" | bc -l)

    echo "=== 평가 결과 비교 ==="
    echo ""
    echo "이전 평가:"
    echo "  평균: $prev_mean"
    echo "  95% CI: [$prev_ci_lower, $prev_ci_upper]"
    echo ""
    echo "현재 평가:"
    echo "  평균: $curr_mean"
    echo "  95% CI: [$curr_ci_lower, $curr_ci_upper]"
    echo ""
    echo "변화:"
    echo "  절대 변화: $delta"
    echo "  상대 변화: ${delta_pct}%"
    echo ""

    if ci_separated "$prev_ci_upper" "$curr_ci_lower"; then
        echo "결과: 통계적으로 유의미한 향상 (p < 0.05)"
        echo "  → 신뢰구간이 분리됨"
    else
        echo "결과: 통계적으로 유의미하지 않음"
        echo "  → 신뢰구간이 겹침 (노이즈 가능성)"
    fi
}

# ------------------------------------------------------------------------------
# 테스트 함수 (이 스크립트 단독 실행 시)
# ------------------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== Statistics Library Test ==="
    echo ""

    # 테스트 데이터
    scores=(82 85 79)
    echo "Test Scores: ${scores[*]}"
    echo ""

    # 평균 계산
    mean=$(calc_mean "${scores[@]}")
    echo "Mean: $mean"

    # 표준편차 계산
    stddev=$(calc_stddev "$mean" "${scores[@]}")
    echo "StdDev: $stddev"

    # 신뢰구간 계산
    mapfile -t ci < <(calc_ci "$mean" "$stddev" 3)
    echo "95% CI: [${ci[0]}, ${ci[1]}]"
    echo ""

    # JSON 생성
    echo "Baseline JSON:"
    generate_baseline_json "${scores[@]}"
    echo ""

    # 신뢰구간 분리 테스트
    echo "CI Separation Test:"
    if ci_separated 87.5 88.0; then
        echo "  87.5 < 88.0: Separated (significant)"
    else
        echo "  87.5 < 88.0: Not separated"
    fi

    if ci_separated 87.5 85.0; then
        echo "  87.5 < 85.0: Separated (significant)"
    else
        echo "  87.5 < 85.0: Not separated"
    fi
fi

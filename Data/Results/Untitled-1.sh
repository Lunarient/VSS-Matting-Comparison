python evaluation/eval_yt_hr.py \
    --pred-dir /workspaces/ESOFProject/Data/Results/Model_A/youtubematte_1920x1080 \
    --true-dir /workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_1920x1080

python evaluation/eval_yt_hr.py \
    --pred-dir /workspaces/ESOFProject/Data/Results/Model_B/youtubematte_1920x1080 \
    --true-dir /workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_1920x1080

python evaluation/eval_yt_hr.py \
    --pred-dir /workspaces/ESOFProject/Data/Results/Model_C/youtubematte_1920x1080 \
    --true-dir /workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_1920x1080

python evaluation/eval_yt_lr.py \
    --pred-dir /workspaces/ESOFProject/Data/Results/Model_A/youtubematte_512x288 \
    --true-dir /workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_512x288

python evaluation/eval_yt_lr.py \
    --pred-dir /workspaces/ESOFProject/Data/Results/Model_B/youtubematte_512x288 \
    --true-dir /workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_512x288

python evaluation/eval_yt_lr.py \
    --pred-dir /workspaces/ESOFProject/Data/Results/Model_C/youtubematte_512x288 \
    --true-dir /workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_512x288
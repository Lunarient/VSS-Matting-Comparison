#!/bin/bash

export CUDA_VISIBLE_DEVICES=0  # supported GPU

log_file="/workspaces/ESOFProject/Data/Results/Model_B/inference_times.csv"
echo "resolution,video_id,subfolder,seconds" > "$log_file"
# Low Res

input_folder="/workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_512x288"
output_folder="/workspaces/ESOFProject/Data/Results/Model_B/youtubematte_512x288"
checkpoint="/workspaces/ESOFProject/Models/Model_B/RVM/pretrained_models/rvm_mobilenetv3.pth"
device="cuda"
resolution="512x288"

cd "$(dirname "$0")/.."

for subfolder in "youtubematte_motion" "youtubematte_static"; do
    subfolder_path="${input_folder}/${subfolder}"
    echo "Processing subfolder: ${subfolder}"

    for video_folder in "${subfolder_path}"/*; do
        if [ -d "${video_folder}" ]; then
            video_id=$(basename "${video_folder}")
            input_frames_folder="${video_folder}/har"

            if [ -d "${input_frames_folder}" ]; then
                echo ""
                echo "Processing video: ${video_id} from ${subfolder}"

                # Start timing
                start_time=$(date +%s)

                python /workspaces/ESOFProject/Models/Model_B/RVM/inference.py \
                    --variant mobilenetv3 \
                    --checkpoint "${checkpoint}" \
                    --device "${device}" \
                    --input-source "${input_frames_folder}" \
                    --downsample-ratio 1 \
                    --output-type png_sequence \
                    --output-composition "${output_folder}/${subfolder}/${video_id}/com" \
                    --output-alpha "${output_folder}/${subfolder}/${video_id}/pha" \
                    --output-foreground "${output_folder}/${subfolder}/${video_id}/fgr" \
                    --output-video-mbps 4 \
                    --seq-chunk 12

                # End timing
                end_time=$(date +%s)
                elapsed=$((end_time - start_time))

                echo "⏱️  ${resolution} → ${video_id} (${subfolder}) took ${elapsed} seconds"

                # Save timing
                echo "${resolution},${video_id},${subfolder},${elapsed}" >> "$log_file"
            fi
        fi
    done
done


# High Res

input_folder="/workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_1920x1080"
output_folder="/workspaces/ESOFProject/Data/Results/Model_B/youtubematte_1920x1080"
resolution="1920x1080"

for subfolder in "youtubematte_motion" "youtubematte_static"; do
    subfolder_path="${input_folder}/${subfolder}"
    echo "Processing subfolder: ${subfolder}"

    for video_folder in "${subfolder_path}"/*; do
        if [ -d "${video_folder}" ]; then
            video_id=$(basename "${video_folder}")
            input_frames_folder="${video_folder}/har"

            if [ -d "${input_frames_folder}" ]; then
                echo ""
                echo "Processing video: ${video_id} from ${subfolder}"

                # Start timing
                start_time=$(date +%s)

                python /workspaces/ESOFProject/Models/Model_B/RVM/inference.py \
                    --variant mobilenetv3 \
                    --checkpoint "${checkpoint}" \
                    --device "${device}" \
                    --input-source "${input_frames_folder}" \
                    --downsample-ratio 0.25 \
                    --output-type png_sequence \
                    --output-composition "${output_folder}/${subfolder}/${video_id}/com" \
                    --output-alpha "${output_folder}/${subfolder}/${video_id}/pha" \
                    --output-foreground "${output_folder}/${subfolder}/${video_id}/fgr" \
                    --output-video-mbps 4 \
                    --seq-chunk 12

                # End timing
                end_time=$(date +%s)
                elapsed=$((end_time - start_time))

                echo "⏱️  ${resolution} → ${video_id} (${subfolder}) took ${elapsed} seconds"

                # Save timing
                echo "${resolution},${video_id},${subfolder},${elapsed}" >> "$log_file"
            fi
        fi
    done
done

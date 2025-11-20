#!/bin/bash


# Low Res
log_file="/workspaces/ESOFProject/Data/Results/Model_A/inference_times.csv"
echo "resolution,video_id,subfolder,seconds" > "$log_file"

input_folder="/workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_512x288"
mask_folder="/workspaces/ESOFProject/Data/YouTubeMatte_first_frame_seg_mask/youtubematte_512x288"
resolution="512x288"

cd "$(dirname "$0")/.."

for subfolder in "youtubematte_motion" "youtubematte_static"; do
  subfolder_path="${input_folder}/${subfolder}"

  echo "Processing subfolder: ${subfolder}"

  for video_folder in "${subfolder_path}"/*; do
    if [ -d "${video_folder}" ]; then
      video_id=$(basename "${video_folder}")

      mask_file="${mask_folder}/${video_id}.png"
      if [ -f "${mask_file}" ]; then

        input_frames_folder="${video_folder}/har"
        if [ -d "${input_frames_folder}" ]; then
          echo "Processing video: ${video_id} from ${subfolder}"

          start_time=$(date +%s)

          python -m evaluation.inference_matanyone_yt \
                  --input_path "${input_frames_folder}" \
                  --mask_path "${mask_file}" \
                  --output_path "/workspaces/ESOFProject/Data/Results/Model_A/youtubematte_512x288/${subfolder}" \
                  --warmup 1 \
                  --erode_kernel 4 \
                  --dilate_kernel 4 \
                  --save_image

          end_time=$(date +%s)
          elapsed=$((end_time - start_time))

          # Save timing info
          echo "${resolution},${video_id},${subfolder},${elapsed}" >> "$log_file"

          echo " ⏱️  Finished ${video_id} in ${elapsed} seconds."
        fi
      fi
    fi
  done
done

# High Res
input_folder="/workspaces/ESOFProject/Data/YouTubeMatte/youtubematte_1920x1080"
mask_folder="/workspaces/ESOFProject/Data/YouTubeMatte_first_frame_seg_mask/youtubematte_1920x1080"
resolution="1920x1080"

cd "$(dirname "$0")/.."


for subfolder in "youtubematte_motion" "youtubematte_static"; do
  subfolder_path="${input_folder}/${subfolder}"

  echo "Processing subfolder: ${subfolder}"

  for video_folder in "${subfolder_path}"/*; do
    if [ -d "${video_folder}" ]; then
      video_id=$(basename "${video_folder}")

      mask_file="${mask_folder}/${video_id}.png"
      if [ -f "${mask_file}" ]; then

        input_frames_folder="${video_folder}/har"
        if [ -d "${input_frames_folder}" ]; then
          echo "Processing video: ${video_id} from ${subfolder}"

          start_time=$(date +%s)

          python -m evaluation.inference_matanyone_yt \
                  --input_path "${input_frames_folder}" \
                  --mask_path "${mask_file}" \
                  --output_path "/workspaces/ESOFProject/Data/Results/Model_A/youtubematte_1920x1080/${subfolder}" \
                  --warmup 10 \
                  --erode_kernel 15 \
                  --dilate_kernel 15 \
                  --save_image

          end_time=$(date +%s)
          duration=$((end_time - start_time))

          # Save timing info
          echo "$(date +"%Y-%m-%d_%H-%M-%S"),Model_A,${subfolder},${video_id},${duration}" >> "$log_file"

          echo " ⏱️  Finished ${video_id} in ${duration} seconds."
        fi
      fi
    fi
  done
done
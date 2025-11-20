#!/bin/bash

export CUDA_VISIBLE_DEVICES=0  # supported GPU
export PYTHONPATH="/workspaces/ESOFProject/Models/Model_C/MODNet:$PYTHONPATH"

root="/workspaces/ESOFProject/Data/YouTubeMatte"
output_root="/workspaces/ESOFProject/Data/Results/Model_C"
ckpt="/workspaces/ESOFProject/Models/Model_C/MODNet/pretrained/modnet_photographic_portrait_matting.ckpt"

log_file="/workspaces/ESOFProject/Data/Results/Model_C/inference_times.csv"
echo "resolution,video_id,subfolder,seconds" > "$log_file"

for resolution in "youtubematte_1920x1080" "youtubematte_512x288"; do
  for subfolder in "youtubematte_motion" "youtubematte_static"; do

    echo "Processing subfolder: ${subfolder}"
    for video_folder in "$root/$resolution/$subfolder"/*; do

      [ -d "$video_folder" ] || continue
      video_id=$(basename "$video_folder")
      start_time=$(date +%s)
      input_dir="$video_folder/har"
      output_dir="$output_root/$resolution/$subfolder/$video_id/pha"

      if [ -d "$input_dir" ]; then
          mkdir -p "$output_dir"

          total=$(ls "$input_dir" | wc -l)

          (
          python /workspaces/ESOFProject/Models/Model_C/MODNet/demo/image_matting/colab/inference.py \
            --input-path "$input_dir" \
            --output-path "$output_dir" \
            --ckpt-path "$ckpt" \
            >/dev/null 2>&1
          ) &
          pid=$!

          while kill -0 "$pid" 2>/dev/null; do
            processed=$(ls "$output_dir" 2>/dev/null | wc -l)
            percent=$((100 * processed / total))
            printf "\rProgress: %3d%% (%d/%d)" "$percent" "$processed" "$total"
            sleep 0.5
          done

          processed=$(ls "$output_dir" 2>/dev/null | wc -l)
          percent=$((100 * processed / total))
          printf "\rProgress: %3d%% (%d/%d) - Done!\n" "$percent" "$processed" "$total"

          wait $pid

      else
          echo "Skipping (no har folder): $video_folder"
      fi

      end_time=$(date +%s)
      elapsed=$((end_time - start_time))

      # Save timing info
      echo "${resolution},${video_id},${subfolder},${elapsed}" >> "$log_file"

      echo " ⏱️  Finished ${video_id} in ${elapsed} seconds."

    done
  done
done

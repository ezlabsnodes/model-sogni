#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models
QUEUE_FILE="download_queue.txt"

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Semua Folder Tujuan
echo "📂 Membuat struktur direktori..."
mkdir -p "$BASE_DIR/diffusion_models"
mkdir -p "$BASE_DIR/unet"
mkdir -p "$BASE_DIR/vae"
mkdir -p "$BASE_DIR/text_encoders"
mkdir -p "$BASE_DIR/clip"
mkdir -p "$BASE_DIR/clip_vision"
mkdir -p "$BASE_DIR/loras"
mkdir -p "$BASE_DIR/audio_encoders"
mkdir -p "$BASE_DIR/checkpoints"
mkdir -p "$BASE_DIR/latent_upscale_models"
mkdir -p "$BASE_DIR/sam2"
mkdir -p "$BASE_DIR/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose"

# 3. Siapkan File Antrean
echo "📝 Menyusun antrean download (bebas duplikat)..."
> "$QUEUE_FILE" # Kosongkan file jika sudah ada

add_to_queue() {
    URL=$1
    FOLDER=$2
    FILENAME=$(basename "$URL")
    
    echo "$URL" >> "$QUEUE_FILE"
    echo "  dir=$BASE_DIR/$FOLDER" >> "$QUEUE_FILE"
    echo "  out=$FILENAME" >> "$QUEUE_FILE"
}

# --- DIFFUSION MODELS ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/qwen_image_edit_2511_fp8mixed.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/qwen_image_2512_fp8_e4m3fn.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_s2v_14B_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/ltx-2-19b-dev-fp8.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors" "diffusion_models"
add_to_queue "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/acestep_v1.5_turbo.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/flux2_dev_fp8mixed.safetensors" "diffusion_models"
add_to_queue "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/z_image_bf16.safetensors" "diffusion_models"
add_to_queue "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/acestep_v1.5_sft.safetensors" "diffusion_models"

# --- VAE ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors" "vae"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/vae/qwen_image_vae.safetensors" "vae"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/vae/ltx-2-vae.safetensors" "vae"
add_to_queue "https://cdn.sogni.ai/vae/ae.safetensors" "vae"
add_to_queue "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/vae/ace_1.5_vae.safetensors" "vae"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/vae/flux2-vae.safetensors" "vae"

# --- TEXT ENCODERS ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/qwen_3_4b.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/text_encoder/clip_l.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/text_encoder/t5xxl_fp8_e4m3fn_scaled.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/mistral_3_small_flux2_fp8.safetensors" "text_encoders"

# --- LORAS ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/Qwen-Image-Lightning-4steps-V1.0.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-distilled-lora-384.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/WanAnimate_relight_lora_fp16.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-lora-camera-control-static.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-detailer.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-canny-control.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-pose-control.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-depth-control.safetensors" "loras"

# --- UNET (Sudah dikoreksi ke diffusion_models) ---
add_to_queue "https://cdn.sogni.ai/unet/flux1-schnell_fp8.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/unet/flux1-krea-dev_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/unet/chroma-unlocked-v46-flash_float8_e4m3fn_scaled_learned.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/unet/chroma-unlocked-v48-detail-calibrated_float8_e4m3fn_scaled_learned_svd.safetensors" "diffusion_models"

# --- CLIP ---
add_to_queue "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/clip/qwen_0.6b_ace15.safetensors" "clip"
add_to_queue "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/clip/qwen_4b_ace15.safetensors" "clip"

# --- LAINNYA ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/clip_vision/clip_vision_h.safetensors" "clip_vision"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/audio_encoders/wav2vec2_large_english_fp16.safetensors" "audio_encoders"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/checkpoints/LTX2_audio_vae_bf16.safetensors" "checkpoints"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/latent_upscale_models/ltx-2-spatial-upscaler-x2-1.0.safetensors" "latent_upscale_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/sam2/sam2_hiera_base_plus.safetensors" "sam2"

# --- DWPOSE ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose/yolox_l.onnx" "custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose"
add_to_queue "https://cdn.sogni.ai/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose/dw-ll_ucoco_384_bs5.torchscript.pt" "custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose"

echo "=========================================="
echo "🚀 MEMULAI ULTIMATE DOWNLOAD VIA ANTREAN..."
echo "=========================================="

# Jalankan 1 Screen Utama untuk aria2c
# -j 5 = 5 file berjalan bersamaan
# -x 16 -s 16 = maksimal 16 koneksi per file
CMD="aria2c --input-file=\"$QUEUE_FILE\" -j 5 -x 16 -s 16 -k 1M -c && echo '✅ SEMUA DOWNLOAD SELESAI!' && sleep 10"
screen -dmS "MasterDownload" bash -c "$CMD"

echo "🎉 Proses antrean (56 file) sedang berjalan di background!"
echo "➡️ Ketik: 'screen -r MasterDownload' untuk melihat persentase download."
echo "➡️ Kalau layar sudah bersih, jangan lupa ritual:"
echo "   chmod -R 777 $BASE_DIR/"
echo "   cd ~/sogni-b200-cluster && docker compose restart"
echo "=========================================="

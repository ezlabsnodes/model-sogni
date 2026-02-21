#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Semua Folder Tujuan
echo "📂 Membuat struktur direktori..."
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/unet
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/clip
mkdir -p $BASE_DIR/clip_vision
mkdir -p $BASE_DIR/loras
mkdir -p $BASE_DIR/audio_encoders
mkdir -p $BASE_DIR/checkpoints
mkdir -p $BASE_DIR/latent_upscale_models
mkdir -p $BASE_DIR/sam2
mkdir -p $BASE_DIR/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose

# Fungsi untuk Menjalankan Screen
launch_download() {
    NAME=$1
    FOLDER=$2
    URL=$3
    
    # Perintah yang dijalankan di dalam screen
    CMD="cd $BASE_DIR/$FOLDER && echo '🚀 DOWNLOAD MULAI: $NAME' && aria2c -x 16 -s 16 -k 1M -c '$URL' && echo '✅ SELESAI! Screen akan menutup dalam 10 detik...' && sleep 10"

    # Jalankan Screen Detached (Background)
    screen -dmS "$NAME" bash -c "$CMD"
    
    echo "✅ Screen '$NAME' berjalan! (Folder: $FOLDER)"
    sleep 0.5 # Jeda agar I/O disk dan CPU B200 tidak bottleneck
}

echo "=========================================="
echo "🚀 MEMULAI ULTIMATE DOWNLOAD (56 FILE UNIK)..."
echo "=========================================="

# --- 1. DIFFUSION MODELS & UNET ---
echo "📥 Sedot Diffusion & Unet..."
launch_download "wan_i2v_high" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"
launch_download "wan_i2v_low" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
launch_download "wan_t2v_high" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors"
launch_download "wan_t2v_low" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors"
launch_download "wan_s2v" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_s2v_14B_fp8_scaled.safetensors"
launch_download "wan_animate" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"
launch_download "qwen_edit" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/qwen_image_edit_2511_fp8mixed.safetensors"
launch_download "qwen_image" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/qwen_image_2512_fp8_e4m3fn.safetensors"
launch_download "ltx2_dev" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/ltx-2-19b-dev-fp8.safetensors"
launch_download "z_turbo" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors"
launch_download "z_image_bf16" "diffusion_models" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/z_image_bf16.safetensors"
launch_download "ace_turbo" "diffusion_models" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/acestep_v1.5_turbo.safetensors"
launch_download "ace_sft" "diffusion_models" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/acestep_v1.5_sft.safetensors"
launch_download "flux2_dev" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/flux2_dev_fp8mixed.safetensors"
launch_download "flux_schnell" "unet" "https://cdn.sogni.ai/unet/flux1-schnell_fp8.safetensors"
launch_download "flux_krea" "unet" "https://cdn.sogni.ai/unet/flux1-krea-dev_fp8_scaled.safetensors"
launch_download "chroma_v46" "unet" "https://cdn.sogni.ai/unet/chroma-unlocked-v46-flash_float8_e4m3fn_scaled_learned.safetensors"
launch_download "chroma_v48" "unet" "https://cdn.sogni.ai/unet/chroma-unlocked-v48-detail-calibrated_float8_e4m3fn_scaled_learned_svd.safetensors"

# --- 2. TEXT ENCODERS & CLIP ---
echo "📥 Sedot Text Encoders..."
launch_download "umt5_xxl" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
launch_download "qwen_vl_7b" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
launch_download "qwen_3_4b" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/qwen_3_4b.safetensors"
launch_download "gemma_12b" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors"
launch_download "mistral_flux2" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/mistral_3_small_flux2_fp8.safetensors"
launch_download "ltx2_conn_dev" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors"
launch_download "ltx2_conn_dis" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors"
launch_download "clip_l" "text_encoders" "https://cdn.sogni.ai/text_encoder/clip_l.safetensors"
launch_download "t5xxl_fp8" "text_encoders" "https://cdn.sogni.ai/text_encoder/t5xxl_fp8_e4m3fn_scaled.safetensors"
launch_download "qwen_06b_ace" "clip" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/clip/qwen_0.6b_ace15.safetensors"
launch_download "qwen_4b_ace" "clip" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/clip/qwen_4b_ace15.safetensors"

# --- 3. VAE ---
echo "📥 Sedot VAE..."
launch_download "wan_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors"
launch_download "qwen_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/qwen_image_vae.safetensors"
launch_download "ltx2_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/ltx-2-vae.safetensors"
launch_download "flux2_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/flux2-vae.safetensors"
launch_download "ae_vae" "vae" "https://cdn.sogni.ai/vae/ae.safetensors"
launch_download "ace_vae" "vae" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/vae/ace_1.5_vae.safetensors"

# --- 4. LORAS ---
echo "📥 Sedot LoRAs..."
launch_download "wan_i2v_lora_hi" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
launch_download "wan_i2v_lora_lo" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"
launch_download "wan_t2v_lora_hi" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors"
launch_download "wan_t2v_lora_lo" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors"
launch_download "qwen_edit_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors"
launch_download "qwen_img_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/Qwen-Image-Lightning-4steps-V1.0.safetensors"
launch_download "ltx2_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-distilled-lora-384.safetensors"
launch_download "ltx2_camera" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-lora-camera-control-static.safetensors"
launch_download "ltx2_detailer" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-detailer.safetensors"
launch_download "ltx2_canny" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-canny-control.safetensors"
launch_download "ltx2_pose" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-pose-control.safetensors"
launch_download "ltx2_depth" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-ic-lora-depth-control.safetensors"
launch_download "wan_anim_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/WanAnimate_relight_lora_fp16.safetensors"
launch_download "lightx2v_i2v_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"

# --- 5. AUDIO, CHECKPOINTS, UPSCALE, VISION, DLL ---
echo "📥 Sedot Komponen Lainnya..."
launch_download "clip_vision" "clip_vision" "https://cdn.sogni.ai/ComfyUI/models/clip_vision/clip_vision_h.safetensors"
launch_download "wav2vec" "audio_encoders" "https://cdn.sogni.ai/ComfyUI/models/audio_encoders/wav2vec2_large_english_fp16.safetensors"
launch_download "ltx2_ckpt" "checkpoints" "https://cdn.sogni.ai/ComfyUI/models/checkpoints/LTX2_audio_vae_bf16.safetensors"
launch_download "ltx2_upscale" "latent_upscale_models" "https://cdn.sogni.ai/ComfyUI/models/latent_upscale_models/ltx-2-spatial-upscaler-x2-1.0.safetensors"
launch_download "yolox_onnx" "custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose" "https://cdn.sogni.ai/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose/yolox_l.onnx"
launch_download "dwpose_pt" "custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose" "https://cdn.sogni.ai/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose/dw-ll_ucoco_384_bs5.torchscript.pt"
launch_download "sam2_base" "sam2" "https://cdn.sogni.ai/ComfyUI/models/sam2/sam2_hiera_base_plus.safetensors"

echo "=========================================="
echo "🎉 56 SCREEN SEDANG BERJALAN DI BACKGROUND!"
echo "Gunakan 'screen -ls' untuk mengecek status."
echo "Kalau layar sudah bersih, jangan lupa ritual wajibnya:"
echo "chmod -R 777 ~/sogni-b200-cluster/data-models/"
echo "cd ~/sogni-b200-cluster && docker compose restart"
echo "=========================================="

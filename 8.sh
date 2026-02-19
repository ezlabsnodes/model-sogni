#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Folder Tujuan (Lengkap dengan unet dan clip)
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/unet
mkdir -p $BASE_DIR/clip

# Fungsi Download Background
launch_download() {
    NAME=$1
    FOLDER=$2
    URL=$3
    
    # Perintah: Masuk folder -> Download -> Selesai -> Tutup Screen
    CMD="cd $BASE_DIR/$FOLDER && echo '🚀 DOWNLOAD: $NAME' && aria2c -x 16 -s 16 -k 1M -c '$URL' && echo '✅ SELESAI!' && sleep 5"

    screen -dmS "$NAME" bash -c "$CMD"
    echo "✅ Screen '$NAME' berjalan! (Folder: $FOLDER)"
}

echo "=========================================="
echo "🚀 DOWNLOAD SET FLUX, CHROMA, Z-IMAGE & ACE 1.5..."
echo "=========================================="

# --- 1. DIFFUSION MODELS ---
launch_download "z_image_turbo" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/z_image_turbo_bf16.safetensors"
launch_download "ace_1.5_turbo" "diffusion_models" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/diffusion_models/acestep_v1.5_turbo.safetensors"

# --- 2. UNET (Model Flux & Chroma) ---
launch_download "flux_schnell" "unet" "https://cdn.sogni.ai/unet/flux1-schnell_fp8.safetensors"
launch_download "flux_krea_dev" "unet" "https://cdn.sogni.ai/unet/flux1-krea-dev_fp8_scaled.safetensors"
launch_download "chroma_v46" "unet" "https://cdn.sogni.ai/unet/chroma-unlocked-v46-flash_float8_e4m3fn_scaled_learned.safetensors"
launch_download "chroma_v48" "unet" "https://cdn.sogni.ai/unet/chroma-unlocked-v48-detail-calibrated_float8_e4m3fn_scaled_learned_svd.safetensors"

# --- 3. VAE ---
launch_download "flux_ae" "vae" "https://cdn.sogni.ai/vae/ae.safetensors"
launch_download "ace_vae" "vae" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/vae/ace_1.5_vae.safetensors"

# --- 4. CLIP / TEXT ENCODERS ---
launch_download "qwen_3_4b" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/qwen_3_4b.safetensors"
launch_download "clip_l" "clip" "https://cdn.sogni.ai/text_encoder/clip_l.safetensors"
launch_download "t5xxl_fp8" "clip" "https://cdn.sogni.ai/text_encoder/t5xxl_fp8_e4m3fn_scaled.safetensors"
launch_download "qwen_0.6b_ace" "clip" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/clip/qwen_0.6b_ace15.safetensors"
launch_download "qwen_4b_ace" "clip" "https://pub-5bc58981af9f42659ff8ada57bfea92c.r2.dev/ComfyUI/models/clip/qwen_4b_ace15.safetensors"

echo "=========================================="
echo "🎉 SEMUA 13 FILE SEDANG DIDOWNLOAD DI BACKGROUND!"
echo "Cek status dengan: screen -ls"
echo "=========================================="

#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Folder Tujuan (Termasuk folder baru untuk LTX)
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/checkpoints
mkdir -p $BASE_DIR/latent_upscale_models
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/loras

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
echo "🚀 MEMULAI DOWNLOAD LTX-2 19B FULL SET..."
echo "=========================================="

# --- 1. DIFFUSION MODEL (Main File) ---
launch_download "ltx_diff_19b" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/ltx-2-19b-dev-fp8.safetensors"

# --- 2. TEXT ENCODERS (Gemma & Connectors) ---
launch_download "ltx_gemma" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors"
launch_download "ltx_conn_dev" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors"
launch_download "ltx_conn_dist" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors"

# --- 3. VAE & AUDIO CHECKPOINT ---
launch_download "ltx_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/ltx-2-vae.safetensors"
# Note: Audio VAE ini masuk ke folder 'checkpoints' sesuai URL
launch_download "ltx_audio_vae" "checkpoints" "https://cdn.sogni.ai/ComfyUI/models/checkpoints/LTX2_audio_vae_bf16.safetensors"

# --- 4. UPSCALER (Latent Upscale) ---
launch_download "ltx_upscaler" "latent_upscale_models" "https://cdn.sogni.ai/ComfyUI/models/latent_upscale_models/ltx-2-spatial-upscaler-x2-1.0.safetensors"

# --- 5. LORA (Distilled) ---
launch_download "ltx_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/ltx-2-19b-distilled-lora-384.safetensors"

echo "=========================================="
echo "🎉 SEMUA 8 FILE LTX-2 SEDANG DIDOWNLOAD DI BACKGROUND!"
echo "Cek status dengan: screen -ls"
echo "=========================================="

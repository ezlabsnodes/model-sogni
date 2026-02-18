#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Folder Tujuan
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/loras

# Fungsi untuk Menjalankan Screen
launch_download() {
    NAME=$1
    FOLDER=$2
    URL=$3
    
    # Perintah: Masuk folder -> Download -> Tunggu 5 detik -> Tutup
    CMD="cd $BASE_DIR/$FOLDER && echo '🚀 DOWNLOAD MULAI: $NAME' && aria2c -x 16 -s 16 -k 1M -c '$URL' && echo '✅ SELESAI! Screen akan menutup...' && sleep 5"

    # Jalankan Screen Detached (Background)
    screen -dmS "$NAME" bash -c "$CMD"
    
    echo "✅ Screen '$NAME' berjalan! (Folder: $FOLDER)"
}

echo "=========================================="
echo "🚀 MEMULAI DOWNLOAD QWEN IMAGE EDIT SET..."
echo "=========================================="

# --- DAFTAR FILE ---

# 1. Diffusion Model (Qwen Image Edit)
launch_download "qwen_diff" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/qwen_image_edit_2511_fp8mixed.safetensors"

# 2. Text Encoder (Qwen 2.5 VL)
launch_download "qwen_enc" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"

# 3. VAE (Qwen Image VAE)
launch_download "qwen_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/qwen_image_vae.safetensors"

# 4. LoRA (Lightning 4-Steps)
launch_download "qwen_lora" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors"

echo "=========================================="
echo "🎉 SEMUA JOB SUDAH DILEPAS KE BACKGROUND!"
echo "Gunakan perintah 'screen -ls' untuk cek status."
echo "=========================================="

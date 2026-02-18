#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Folder Tujuan (Kalau belum ada)
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/loras

# Fungsi untuk Menjalankan Screen
launch_download() {
    NAME=$1
    FOLDER=$2
    URL=$3
    
    # Perintah: Download -> Selesai -> Tunggu 10 detik -> Tutup Screen
    CMD="cd $BASE_DIR/$FOLDER && echo '🚀 DOWNLOAD: $NAME' && aria2c -x 16 -s 16 -k 1M -c '$URL' && echo '✅ SELESAI!' && sleep 10"

    # Jalankan di Background
    screen -dmS "$NAME" bash -c "$CMD"
    
    echo "✅ Screen '$NAME' berjalan! (Target: $FOLDER)"
}

echo "=========================================="
echo "🚀 MEMULAI DOWNLOAD WAN 2.2 T2V (Text-to-Video)..."
echo "=========================================="

# --- DAFTAR FILE ---

# 1. Diffusion Models (File Utama)
launch_download "t2v_diff_high" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors"
launch_download "t2v_diff_low" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors"

# 2. LoRA Versi 1.1 (Khusus T2V)
launch_download "t2v_lora_high" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors"
launch_download "t2v_lora_low" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors"

# 3. Pendukung (VAE & T5)
# Catatan: Kalau file ini sudah ada (dari I2V), aria2 akan otomatis SKIP. Aman.
launch_download "wan_vae_t2v" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors"
launch_download "wan_t5_t2v" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

echo "=========================================="
echo "🎉 SEMUA JOB SUDAH DILEPAS KE BACKGROUND!"
echo "Gunakan perintah 'screen -ls' untuk memantau."
echo "=========================================="

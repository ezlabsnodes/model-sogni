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
mkdir -p $BASE_DIR/clip_vision
mkdir -p $BASE_DIR/loras

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
}

echo "=========================================="
echo "🚀 MEMULAI 7 TURBO DOWNLOAD SEKALIGUS..."
echo "=========================================="

# --- DAFTAR FILE ---

# 1. Diffusion High Noise (14GB)
launch_download "wan_diff_high" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"

# 2. Diffusion Low Noise (14GB)
launch_download "wan_diff_low" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"

# 3. VAE
launch_download "wan_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors"

# 4. Text Encoder (UMT5)
launch_download "wan_t5" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# 5. Clip Vision
launch_download "wan_clip" "clip_vision" "https://cdn.sogni.ai/ComfyUI/models/clip_vision/clip_vision_h.safetensors"

# 6. LoRA High Noise
launch_download "wan_lora_high" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"

# 7. LoRA Low Noise
launch_download "wan_lora_low" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"

echo "=========================================="
echo "🎉 SEMUA JOB SUDAH DILEPAS KE BACKGROUND!"
echo "Gunakan perintah 'screen -ls' untuk melihat status."
echo "=========================================="

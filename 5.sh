#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Folder Tujuan (Lengkap)
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/clip_vision
mkdir -p $BASE_DIR/loras
mkdir -p $BASE_DIR/audio_encoders

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
echo "🚀 DOWNLOAD PAKET LENGKAP WAN 2.2 (S2V + I2V + T2V LoRA)"
echo "=========================================="

# --- 1. DIFFUSION MODELS (Video) ---
launch_download "wan_s2v_diff" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_s2v_14B_fp8_scaled.safetensors"
launch_download "wan_i2v_high" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"
launch_download "wan_i2v_low" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"

# --- 2. AUDIO ENCODER (Khusus S2V) ---
launch_download "wan_audio" "audio_encoders" "https://cdn.sogni.ai/ComfyUI/models/audio_encoders/wav2vec2_large_english_fp16.safetensors"

# --- 3. LORAS (I2V & T2V v1.1) ---
# I2V LoRAs
launch_download "lora_i2v_high" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
launch_download "lora_i2v_low" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"

# T2V LoRAs 
launch_download "lora_t2v_high_1.1" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors"
launch_download "lora_t2v_low_1.1" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors"

# --- 4. PENDUKUNG LAINNYA ---
launch_download "wan_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors"
launch_download "wan_t5" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
launch_download "wan_clip" "clip_vision" "https://cdn.sogni.ai/ComfyUI/models/clip_vision/clip_vision_h.safetensors"

echo "=========================================="
echo "🎉 SEMUA 11 FILE SEDANG DIDOWNLOAD DI BACKGROUND!"
echo "Cek status dengan: screen -ls"
echo "=========================================="

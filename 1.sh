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
mkdir -p "$BASE_DIR/vae"
mkdir -p "$BASE_DIR/text_encoders"
mkdir -p "$BASE_DIR/clip_vision"
mkdir -p "$BASE_DIR/loras"

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

# --- DIFFUSION MODELS (Core Models) ---
# Wan 2.2 14B I2V (High & Low Noise)
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors" "diffusion_models"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors" "diffusion_models"
# LTX 2.3 22B Distilled (Dipakai untuk T2V & I2V)
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_scaled.safetensors" "diffusion_models"

# --- VAE (Wajib untuk decoding video) ---
# VAE untuk Wan 2.2
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors" "vae"
# VAE khusus LTX 2.3
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/vae/LTX23_video_vae_bf16.safetensors" "vae"

# --- TEXT ENCODERS (Wajib untuk membaca prompt teks) ---
# Text Encoders untuk Wan & LTX
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/text_encoder/t5xxl_fp8_e4m3fn_scaled.safetensors" "text_encoders"
add_to_queue "https://cdn.sogni.ai/text_encoder/clip_l.safetensors" "text_encoders"
# Projection khusus LTX 2.3
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/text_encoders/ltx-2.3_text_projection_bf16.safetensors" "text_encoders"

# --- CLIP VISION (Wajib untuk Wan I2V Image Reference) ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/clip_vision/clip_vision_h.safetensors" "clip_vision"

# --- LORAS (Khusus untuk Wan LightX2V) ---
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors" "loras"
add_to_queue "https://cdn.sogni.ai/ComfyUI/models/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors" "loras"

echo "=========================================="
echo "🚀 MEMULAI ULTIMATE DOWNLOAD VIA ANTREAN..."
echo "=========================================="

# Jalankan 1 Screen Utama untuk aria2c
CMD="aria2c --input-file=\"$QUEUE_FILE\" -j 5 -x 16 -s 16 -k 1M -c && echo '✅ SEMUA DOWNLOAD SELESAI!' && sleep 10"
screen -dmS "MasterDownload" bash -c "$CMD"

echo "🎉 Proses antrean elit (12 file esensial) sedang berjalan di background!"
echo "➡️ Ketik: 'screen -r MasterDownload' untuk melihat persentase download."
echo "➡️ Ritual akhir setelah selesai:"
echo "    chmod -R 777 $BASE_DIR/"
echo "    cd ~/sogni-b200-cluster && docker compose restart"
echo "=========================================="

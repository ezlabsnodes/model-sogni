#!/bin/bash

# --- KONFIGURASI ---
BASE_DIR=~/sogni-b200-cluster/data-models

# 1. Pastikan Tools Terinstall
echo "🔧 Mengecek tools..."
apt update -qq
apt install -y screen aria2

# 2. Buat Folder Tujuan (Termasuk folder khusus annotators & sam2)
mkdir -p $BASE_DIR/vae
mkdir -p $BASE_DIR/text_encoders
mkdir -p $BASE_DIR/diffusion_models
mkdir -p $BASE_DIR/loras
mkdir -p $BASE_DIR/clip_vision
mkdir -p $BASE_DIR/sam2
mkdir -p $BASE_DIR/annotators/dwpose

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
echo "🚀 DOWNLOAD WAN 2.2 ANIMATE & CONTROLNET SET..."
echo "=========================================="

# --- 1. DIFFUSION MODELS (Animate & I2V) ---
launch_download "wan_animate_kj" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"
launch_download "wan_i2v_high" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"
launch_download "wan_i2v_low" "diffusion_models" "https://cdn.sogni.ai/ComfyUI/models/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"

# --- 2. CONTROLNET / ANNOTATORS (DWPose) ---
# Note: DWPose biasanya masuk ke folder annotators/dwpose
launch_download "dwpose_onnx" "annotators/dwpose" "https://cdn.sogni.ai/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose/yolox_l.onnx"
launch_download "dwpose_torch" "annotators/dwpose" "https://cdn.sogni.ai/ComfyUI/custom_nodes/comfyui_controlnet_aux/ckpts/yzd-v/DWPose/dw-ll_ucoco_384_bs5.torchscript.pt"

# --- 3. LORAS (Relight & Distill) ---
launch_download "wan_relight" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/WanAnimate_relight_lora_fp16.safetensors"
launch_download "wan_lightx2v" "loras" "https://cdn.sogni.ai/ComfyUI/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"

# --- 4. SAM2 (Segment Anything) ---
launch_download "sam2_hiera" "sam2" "https://cdn.sogni.ai/ComfyUI/models/sam2/sam2_hiera_base_plus.safetensors"

# --- 5. PENDUKUNG (VAE, T5, Clip) ---
launch_download "wan_vae" "vae" "https://cdn.sogni.ai/ComfyUI/models/vae/wan_2.1_vae.safetensors"
launch_download "wan_t5" "text_encoders" "https://cdn.sogni.ai/ComfyUI/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
launch_download "wan_clip" "clip_vision" "https://cdn.sogni.ai/ComfyUI/models/clip_vision/clip_vision_h.safetensors"

echo "=========================================="
echo "🎉 SEMUA 11 FILE SEDANG DIDOWNLOAD DI BACKGROUND!"
echo "Cek status dengan: screen -ls"
echo "=========================================="

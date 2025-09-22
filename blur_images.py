#!/usr/bin/env python3
from PIL import Image, ImageFilter
import os

def blur_region(image, x, y, width, height, blur_radius=10):
    """특정 영역을 블러 처리"""
    # 블러 처리할 영역 추출
    region = image.crop((x, y, x + width, y + height))
    
    # 블러 처리
    blurred_region = region.filter(ImageFilter.GaussianBlur(radius=blur_radius))
    
    # 원본 이미지에 블러 처리된 영역 붙여넣기
    image.paste(blurred_region, (x, y))
    
    return image

def process_image(image_path, blur_regions):
    """이미지를 로드하고 지정된 영역들을 블러 처리"""
    try:
        image = Image.open(image_path)
        
        for region in blur_regions:
            x, y, width, height = region
            image = blur_region(image, x, y, width, height)
        
        image.save(image_path)
        print(f"Processed: {image_path}")
        return True
    except Exception as e:
        print(f"Error processing {image_path}: {e}")
        return False

# 각 이미지별 블러 처리할 영역 정의 (x, y, width, height)
blur_configs = {
    "3.Application/custom/image-2.png": [
        (422, 264, 400, 25),  # Repository URL
        (422, 327, 300, 25),  # Username
    ],
    "3.Application/custom/image.png": [
        (186, 150, 600, 30),  # pipeline_alertnow-webapp_v2_kbds-stg
        (200, 218, 200, 20),  # kimutae1 email
        (834, 218, 200, 20),  # kimutae1 email (right side)
        (574, 442, 150, 25),  # alertnowwebappv2
        (1000, 397, 150, 25), # alertnowwebappv2 (right)
        (1000, 487, 200, 25), # alertnowwebappv2-gzzjq
        (1000, 578, 200, 25), # alertnowwebappv2-canary
        (1000, 669, 250, 25), # alertnowwebappv2-canary-xk
        (1000, 759, 250, 25), # alertnowwebappv2-rollout-76
        (1000, 849, 250, 25), # alertnowwebappv2-rollout-76
        (574, 623, 200, 25),  # alertnowwebappv2-canary
        (574, 804, 200, 25),  # alertnowwebappv2-rollout
        (574, 895, 150, 25),  # alertnowwebappv2 (bottom)
    ]
}

def main():
    base_dir = "/work/repo/private-eks"
    
    for image_file, regions in blur_configs.items():
        image_path = os.path.join(base_dir, image_file)
        if os.path.exists(image_path):
            process_image(image_path, regions)
        else:
            print(f"Warning: Image not found: {image_path}")

if __name__ == "__main__":
    main()

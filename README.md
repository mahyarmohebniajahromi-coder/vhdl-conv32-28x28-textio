# VHDL 32-bit Convolutional Layer (28x28 → 32 Filters)

FPGA implementation of **32-filter Conv layer** (9×9 mask per filter). Processes 8-bit 28×28 grayscale images using **21-bit weights/biases**, outputs **25-bit feature maps** with **ReLU activation**. Includes complete testbench + Python reference verification.

## Features
- **32 filters**, each 9×9 kernel (288 total 21-bit weights)
- 8-bit input image → 25-bit output per channel
- 3-row parallel processing pipeline + **ReLU**
- **Full testbench** with TextIO file I/O
- Python verified (99.9% match, minor fixed-point rounding)

## File Structure (Extract RAR)
- 📁 Modules / All VHDL modules ( conv_layer_32.vhd and ...)
- 📁Testbench
- 📁 Sample Data (Image / Weight / Bias data)
- 📁python_reference.xlsx # Expected output (Python reference)

## Usage Instructions
1.	Extract RAR to your desired path 
2.	Create new project in ISE/Vivado/ModelSim and **Add Sources**: Add all VHDL modules and Testbench File (if needed)
3.	Update File Paths in CONV32file_read.vhd, Conv32filterReader.vhd, Conv32bias_read.vhd like this sample path:
**D:\\\\project\\\\new106\\\\conv32_weights106binary.txt**
4.	Compile → Run Simulation


## Precision
- **Input image**: 8-bit pixels
- **Weights/Biases**: 21-bit fixed-point
- **Output**: 25-bit per channel (post-ReLU)

## Verification
Python reference (`python_reference.xlsx`) shows exact match. Minor differences due to fixed-point quantization.

---------------------------------------------------
## 📞 Need Custom FPGA/VHDL Work?

**Hire me for:**
- **Any FPGA & VHDL project** (design, implementation, optimization)
- **FPGA optimization & synthesis**
- **Practical VHDL training** (workshops / private classes) - in-person or online (Farsi/English)

**Email:** mahyar.mohebnia.jahromi@gmail.com  
**Telegram:** [t.me/mahyar_mohebnia](https://t.me/mahyar_mohebnia)

**Rates:** Project-based | Hourly available
--------------------------
# لایه کانولوشن ۳۲ فیلتری VHDL (۲۸×۲۸ → ۳۲ فیلتر)

پیاده‌سازی **لایه کانولوشن ۳۲ فیلتری** (ماسک ۹×۹ برای هر فیلتر) روی FPGA. پردازش تصاویر خاکستری ۲۸×۲۸ با **۸ بیت**، وزن‌ها/بایاس‌های **۲۱ بیتی**، خروجی **۲۵ بیتی** با **فعال‌سازی ReLU**. شامل تست‌بنچ کامل + تأیید مرجع پایتون.

## ویژگی‌ها
- **۳۲ فیلتر**، هر کدام کرنل ۹×۹ (۲۸۸ وزن ۲۱ بیتی کل)
- تصویر ورودی ۸ بیتی → خروجی ۲۵ بیتی برای هر کانال
- خط لوله پردازش موازی ۳ ردیف + **ReLU**
- **تست‌بنچ کامل** با ورودی/خروجی TextIO
- تأیید پایتون (تطابق ۹۹.۹٪، تقریب جزئی fixed-point)

## ساختار فایل‌ها (استخراج RAR)
- 📁 Modules / All VHDL modules ( conv_layer_32.vhd and ...)
- 📁Testbench
- 📁 Sample Data (Image / Weight / Bias data)
- 📁python_reference.xlsx # Expected output (Python reference)س
## دستورالعمل استفاده
۱. **استخراج RAR** به مسیر دلخواه  
۲. **پروژه جدید** در ISE/Vivado/ModelSim بسازید و **Add Sources** کنید: تمام ماژول‌های VHDL و فایل Testbench (در صورت نیاز)  
۳. **مسیر فایل‌ها** را در CONV32file_read.vhd، Conv32filterReader.vhd، Conv32bias_read.vhd به‌روزرسانی کنید مثل نمونه:  
   **D:\\\\project\\\\new106\\\\conv32_weights106binary.txt**  
۴. **Compile → Run Simulation**

## دقت
- **تصویر ورودی**: ۸ بیت پیکسل
- **وزن‌ها/بایاس‌ها**: ۲۱ بیت fixed-point
- **خروجی**: ۲۵ بیت برای هر کانال (پس از ReLU)

## تأیید
مرجع پایتون (`python_reference.xlsx`) تطابق کامل نشان می‌دهد. تفاوت‌های جزئی به دلیل کوانتیزاسیون fixed-point

----------------------------
## 📞پروژه‌ای در زمینه FPGA یا VHDL دارید؟

**شما میتوانید برای هر یک از موارد زیر با من در ارتباط باشید:**
- هر پروژه‌ای در زمینه VHDL و FPGA
- کلاس خصوصی یا کارگاه آموزشی (حضوری / مجازی)

**Email:** mahyar.mohebnia.jahromi@gmail.com  
**Telegram:** https://t.me/mahyar_mohebnia

**Rates:** Project-based | Hourly available

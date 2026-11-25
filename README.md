# 🛒 Analisis Customer Loyalty & Repeat Purchase E-commerce Indonesia

Proyek analitik data *end-to-end* untuk memahami perilaku pelanggan, pembelian berulang (*repeat purchase*), dan retensi
pada **1.000 transaksi e-commerce Indonesia (1 Juni – 31 Juli 2022)**.

**Tools:** Excel · SQL (SQLite) · Python (pandas, matplotlib, seaborn) · Power BI

---

## 🎯 Pertanyaan Bisnis
1. Seberapa besar proporsi pelanggan yang membeli lebih dari sekali?
2. Berapa banyak pelanggan yang benar-benar **kembali** setelah beberapa waktu (retensi)?
3. Kategori dan produk apa yang paling mendorong pembelian berulang?
4. Siapa pelanggan terbaik, dan siapa yang berisiko hilang? (segmentasi RFM)
5. Apakah gender, usia, dan kota memengaruhi perilaku beli?

## 📦 Dataset
| Kolom | Arti |
|---|---|
| `Trx_Date` | Tanggal transaksi (1 Jun – 31 Jul 2022) |
| `Cust_ID` | ID pelanggan (178 pelanggan unik) |
| `Age`, `Gender`, `AREA` | Usia, jenis kelamin, kota (32 kota) |
| `Product_ID`, `Product_Name`, `Category` | Produk (122 produk, 13 kategori) |
| `Amount` | **Jumlah unit** yang dibeli per transaksi |

> ⚠️ Dataset **tidak memiliki harga**, sehingga tidak ada analisis omzet/revenue. Pada RFM, *Monetary* diganti dengan **total unit** yang dibeli.

## 🧹 Pembersihan Data
- Format tanggal `m/d/yyyy` diubah menjadi tipe tanggal.
- 1 kategori salah (`E`) diperbaiki menjadi `Body Treatment` (berdasarkan produk yang sama, *Hand Cream HIJ*).
- Ejaan `Convinience Goods` diperbaiki menjadi `Convenience Goods`.
- Ditambahkan kolom `month`, `weekday`, dan `age_group`.
- Hasil cek: tidak ada data kosong dan tidak ada duplikat.

---

## 🔍 Temuan Utama

### 1. Repeat rate tinggi (93,8%), tetapi menyesatkan
| Metrik | Nilai |
|---|---|
| Total pelanggan | **178** |
| Pelanggan repeat (≥ 2 transaksi) | **167 (93,8%)** |
| Rata-rata transaksi per pelanggan | **5,6** (median 4) |
| Pelanggan beli 1× saja | 11 |

Namun **97,3% jarak antar pembelian hanya 1 hari** dan median rentang aktif pelanggan repeat hanya **4 hari**.
Artinya banyak pelanggan membeli beruntun dalam beberapa hari lalu berhenti, bukan kembali secara berkala.

### 2. Retensi sejati jauh lebih rendah
| Ukuran retensi | Hasil |
|---|---|
| Pelanggan Juni yang kembali beli di Juli | **28,6%** (30 dari 105) |
| Kembali ≥ 7 hari setelah pembelian pertama | **30,7%** (51 dari 166) |
| Kembali ≥ 30 hari setelah pembelian pertama | **15,7%** (17 dari 108) |

Jumlah pelanggan aktif stabil (105 di Juni, 103 di Juli), tetapi **73 dari 103 pelanggan Juli adalah pelanggan baru**.
Bisnis ini menggantikan pelanggan yang pergi dengan pelanggan baru, bukan mempertahankan yang lama.

### 3. Kosmetik adalah mesin repeat purchase
- **Cosmetics**: 39% dari seluruh transaksi dan repeat rate di kategori **78,6%**.
- Body Treatment (60,0%) dan Electronics & Gadget (59,4%) menyusul, lalu Hair Treatment (47,4%).
- Produk tahan lama (Computer 19,2%, Home Appliances 21,9%, Kitchen Appliances 20,0%) jarang dibeli ulang.
- *Equipments* dan *Books* belum punya pembeli yang mengulang di kategori yang sama (jumlah pelanggannya kecil).

### 4. Segmentasi RFM
| Segmen | Pelanggan | Ciri |
|---|---|---|
| Champions | 21 (11,8%) | Baru beli, sangat sering, unit besar |
| Aktif / Potensial | 38 | Baru beli, frekuensi sedang |
| Loyal (mulai menjauh) | 38 | Dulu sangat sering (rata-rata 10,5 trx), sudah lama tidak beli |
| Perlu Perhatian | 38 | Recency dan frekuensi menengah |
| At Risk | 16 | Lama tidak beli, tetapi dulu cukup sering |
| Lost / Hibernating | 27 | Lama tidak beli dan hanya sedikit transaksi |

**28 pelanggan (15,7%) yang punya ≥ 10 transaksi menyumbang 38,8% dari semua transaksi**, jadi menjaga mereka sangat penting.

### 5. Demografi dan wilayah
- **Perempuan** lebih loyal: repeat rate 97,0% vs 89,6% laki-laki, dan 6,1 vs 5,0 transaksi per pelanggan.
- **Usia** hampir tidak membedakan repeat rate (92–95%). Sekitar 76% pelanggan berusia 35–60 tahun.
- **Kota**: Medan dan Manado tertinggi (masing-masing 70 transaksi). Jumlah pelanggan per kota sangat kecil (5–12), jadi perbedaan antar kota belum bisa disimpulkan.

---

## 💡 Rekomendasi
1. **Fokus ke retensi, bukan hanya akuisisi.** Hanya 3 dari 10 pelanggan Juni yang kembali di Juli. Kirim promo atau pengingat sekitar 1–2 minggu setelah pembelian pertama.
2. **Jadikan Kosmetik sebagai produk pintu masuk.** Pelanggan yang pertama kali membeli Cosmetics 98,3% menjadi repeat. Tawarkan *bundling* lintas kategori (Body & Hair Treatment).
3. **Kampanye win-back** untuk 81 pelanggan di segmen Loyal (mulai menjauh), At Risk, dan Lost, dengan prioritas ke segmen Loyal karena nilainya tertinggi.
4. **Program loyalitas untuk Champions** dan pelanggan dengan ≥ 10 transaksi (akses awal, poin, gratis ongkir).
5. **Produk tahan lama** (laptop, peralatan rumah) perlu strategi berbeda, misalnya aksesori atau layanan purna jual, karena jarang dibeli ulang.

## ⚠️ Keterbatasan
- Periode hanya 2 bulan, jadi retensi jangka panjang belum bisa diukur.
- Tidak ada kolom harga/omzet dan tidak ada ID pesanan (satu baris = satu transaksi).
- 17 transaksi membeli ≥ 10 unit sekaligus (maks 30 unit) dan menyumbang 16,4% dari seluruh unit. Kemungkinan pembelian grosir/reseller, tidak dibuang dari analisis.
- Pola pembelian beruntun yang sangat seragam menunjukkan data kemungkinan sintetis/simulasi, jadi gunakan untuk latihan dan portofolio, bukan keputusan bisnis nyata.
- Ukuran sampel per kota dan per kategori kecil, jadi bacalah sebagai indikasi, bukan kesimpulan pasti.

---

## 🗂️ Struktur Proyek
```
├── data/
│   ├── repeatbuyer_ecommerce_indo                
│   └── transactions_clean.csv
│   └── customer_summary.csv      
├── EDA_loyalti_repeat_purchase.ipynb     
├── dashboard_powerbi_ecommerce_loyalty.png                  
├── requirements.txt

```

## 🧠 Yang Saya Pelajari / Tunjukkan
Data cleaning · Analisis kohort & retensi · Segmentasi RFM · Visualisasi data · Storytelling bisnis · Kesadaran akan keterbatasan data

---


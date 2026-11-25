# Panduan Membuat Dashboard Power BI (untuk pemula)

File `.pbix` dibuat langsung di aplikasi **Power BI Desktop** (gratis, Windows). Ikuti langkah di bawah,
lalu simpan sebagai `powerbi/repeat_buyer_dashboard.pbix` dan taruh screenshot-nya di folder `images/`.

## 1. Masukkan data
1. Buka Power BI Desktop → **Get data → Text/CSV**.
2. Pilih `data/processed/transactions_clean.csv` → **Transform Data**.
   - Pastikan `trx_date` bertipe **Date**. Klik **Close & Apply**.
3. Ulangi untuk `data/processed/customer_summary.csv`.
   - Ubah kolom `first_date` dan `last_date` menjadi tipe **Date**.

## 2. Hubungkan tabel (Model view)
Tarik `customer_summary[cust_id]` ke `transactions_clean[cust_id]`.
Pastikan relasinya **One (customer_summary) → Many (transactions_clean)**.

## 3. Buat Measure (DAX)
Klik kanan tabel `transactions_clean` → **New measure**, lalu tempel satu per satu:

```DAX
Total Transaksi = COUNTROWS(transactions_clean)

Total Pelanggan = DISTINCTCOUNT(transactions_clean[cust_id])

Total Unit = SUM(transactions_clean[quantity])

Pelanggan Repeat =
CALCULATE(DISTINCTCOUNT(customer_summary[cust_id]), customer_summary[n_trx] >= 2)

Repeat Rate = DIVIDE([Pelanggan Repeat], [Total Pelanggan])

Rata2 Transaksi per Pelanggan = DIVIDE([Total Transaksi], [Total Pelanggan])

Kohort Juni =
CALCULATE(DISTINCTCOUNT(customer_summary[cust_id]), customer_summary[first_month] = "2022-06")

Kohort Juni Kembali di Juli =
CALCULATE(
    DISTINCTCOUNT(customer_summary[cust_id]),
    customer_summary[first_month] = "2022-06",
    customer_summary[last_date] >= DATE(2022, 7, 1)
)

Retensi Juni ke Juli = DIVIDE([Kohort Juni Kembali di Juli], [Kohort Juni])
```
Atur format: `Repeat Rate` dan `Retensi Juni ke Juli` → **Percentage**, 1 desimal.

## 4. Susun 3 halaman dashboard

**Halaman 1 - Ringkasan**
- 4 kartu (Card): Total Pelanggan, Total Transaksi, Repeat Rate, Retensi Juni ke Juli
- Line chart: Axis = `trx_date` (level Week/Month), Values = Total Transaksi
- Bar chart: Axis = `category`, Values = Total Transaksi
- Slicer: `gender`, `age_group`

**Halaman 2 - Perilaku Pelanggan**
- Column chart: Axis = `customer_summary[n_trx]`, Values = Count of `cust_id` (distribusi frekuensi beli)
- Bar chart: Top 10 `area` menurut Total Transaksi (Filter pane → Top N = 10)
- Tabel: `product_name`, Total Transaksi, Total Unit (urutkan menurun)

**Halaman 3 - Segmentasi RFM**
- Donut / bar chart: Axis = `customer_summary[segmen]`, Values = Count of `cust_id`
- Tabel pelanggan: `cust_id`, `recency`, `n_trx`, `total_qty`, `segmen`
- Slicer: `segmen`

## 5. Tips tampilan
- Pakai 1-2 warna saja (misal biru dan oranye) agar rapi.
- Beri judul jelas di tiap visual, contoh "Transaksi per Kategori".
- Terakhir: **File → Export → Screenshot**, atau gunakan Windows + Shift + S, simpan ke `images/dashboard_powerbi.png`,
  lalu tambahkan baris `![Dashboard](images/dashboard_powerbi.png)` di `README.md`.

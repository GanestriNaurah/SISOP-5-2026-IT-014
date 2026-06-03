# Laporan Praktikum Modul 5

# Soal 1 - Farewell Party

## Solve Code

Pada soal ini dibuat sebuah sistem operasi sederhana berbasis Linux Kernel 6.1.1 dengan BusyBox sebagai userspace. Pengerjaan dilakukan dengan melengkapi beberapa script, yaitu `kernel.sh`, `single.sh`, `multi.sh`, `iso.sh`, `qemu.sh`, dan `backup.sh`.

### Build Linux Kernel

Script `kernel.sh` digunakan untuk mengunduh source Linux Kernel 6.1.1, melakukan konfigurasi menggunakan file `.config`, kemudian mengompilasi kernel hingga menghasilkan file `bzImage`.

```bash
make -j$(nproc)
cp arch/x86/boot/bzImage ../osboot/bzImage
```

Output akhir tahap ini adalah file:

```text
osboot/bzImage
```

### Membuat Single User Filesystem

Script `single.sh` digunakan untuk membangun root filesystem berbasis BusyBox dengan satu user yaitu `root`.

BusyBox digunakan sebagai shell utama dengan membuat symbolic link seluruh applet:

```bash
busybox --install -s bin
```

Filesystem kemudian dikemas menjadi initramfs:

```bash
find . | cpio -o -H newc | gzip > ../osboot/single.gz
```

Output dari tahap ini adalah:

```text
osboot/single.gz
```

### Membuat Multi User Filesystem

Script `multi.sh` digunakan untuk membuat filesystem dengan beberapa user:

```text
root
henn
hann
viii
kids
```

Setiap user memiliki home directory masing-masing dan dikonfigurasi melalui file `/etc/passwd` dan `/etc/shadow`.

Filesystem kemudian dikemas menjadi:

```text
osboot/multi.gz
```
<img width="1178" height="415" alt="Screenshot 2026-05-30 214108" src="https://github.com/user-attachments/assets/2e2ef209-1139-4990-9a61-ea12be15afee" />

### Membuat ISO Bootable

Script `iso.sh` digunakan untuk membuat image ISO yang berisi kernel dan initramfs yang telah dibuat sebelumnya.

```bash
grub-mkrescue
```

Output:

```text
osboot/farewell.iso
```
<img width="1412" height="779" alt="Screenshot 2026-05-30 214321" src="https://github.com/user-attachments/assets/2f3e18f3-e9ed-4485-b1d4-18c732d463c7" />

### Menjalankan Sistem Operasi

Script `qemu.sh` digunakan untuk menjalankan sistem operasi dalam tiga mode:

```bash
./qemu.sh --single
```
<img width="1439" height="756" alt="Screenshot 2026-05-30 214410" src="https://github.com/user-attachments/assets/1647b7ff-c5cc-4fc8-a1bf-a87d8ead9bbc" />

Digunakan untuk boot ke single user filesystem.

```bash
./qemu.sh --multi
```
<img width="1451" height="835" alt="Screenshot 2026-05-30 214739" src="https://github.com/user-attachments/assets/926cd753-9d8c-4a84-8d7e-b02fd00b27d6" />

Digunakan untuk boot ke multi user filesystem.

```bash
./qemu.sh --all
```
<img width="1438" height="909" alt="Screenshot 2026-05-30 214758" src="https://github.com/user-attachments/assets/c89cb388-5e83-472e-9ee2-0ca9e793789f" />

Digunakan untuk boot melalui ISO dan menampilkan menu GRUB.

### Backup Hasil Build

Script `backup.sh` digunakan untuk membuat arsip hasil build sehingga seluruh output dapat disimpan dalam satu file zip.

---

## Output

### Build Kernel

Berhasil menghasilkan file:

```text
osboot/bzImage
```

### Single User Filesystem

Berhasil menghasilkan file:

```text
osboot/single.gz
```

### Multi User Filesystem

Berhasil menghasilkan file:

```text
osboot/multi.gz
```

### ISO Bootable

Berhasil menghasilkan file:

```text
osboot/farewell.iso
```

### Pengujian Sistem Operasi

Sistem operasi berhasil dijalankan menggunakan QEMU baik pada mode single user maupun multi user.

### Pengujian Internet

```bash
ping 8.8.8.8
```

```text
64 bytes from 8.8.8.8
64 bytes from 8.8.8.8
```

### Pengujian Package Manager

```bash
party install fuse
```

```text
Installing fuse...
Done
```

---

## Problem

* Proses kompilasi Linux Kernel membutuhkan waktu cukup lama karena ukuran source code yang besar.
* Konfigurasi BusyBox sempat menyebabkan shell tidak dapat dijalankan dengan benar.
* Pengaturan user dan permission pada multi-user filesystem perlu disesuaikan agar sesuai spesifikasi soal.
* Konfigurasi GRUB sempat gagal mendeteksi initramfs yang digunakan untuk proses booting.
* Pengujian koneksi internet pada QEMU memerlukan konfigurasi network tambahan.
* Instalasi dan pengujian FUSE memerlukan library yang sesuai di dalam filesystem.

---

# Soal 2 - Assistant's Last Gift

## Solve Code

Pada soal ini dibuat sebuah sistem operasi sederhana berbasis 16-bit menggunakan bootloader dan kernel yang telah disediakan. Praktikan hanya diperbolehkan mengubah file `kernel.asm` dan `kernel.c`.

### Implementasi Input Keyboard

Fungsi `_getChar()` diimplementasikan menggunakan BIOS Interrupt `0x16` untuk membaca input keyboard.

```asm
_getChar:
    mov ah, 0x00
    int 0x16
    ret
```

### Implementasi Command Check

Command `check` digunakan untuk memastikan sistem berjalan dengan baik.

```c
if (strcmp(cmd, "check")) {
    printString("ok");
}
```

### Implementasi Command Help

Command `help` digunakan untuk menampilkan seluruh command yang tersedia.

```c
else if (strcmp(cmd, "help")) {
    printString(
        "check add sub fac season triangle clear about"
    );
}
```

### Implementasi Command Add

Command `add` digunakan untuk melakukan operasi penjumlahan.

```c
else if (startsWith(cmd, "add ")) {

    a = atoi(cmd + 4);
    b = atoi(cmd + 6);

    intToString(a + b, result);
    printString(result);
}
```

### Implementasi Command Sub

Command `sub` digunakan untuk melakukan operasi pengurangan.

```c
else if (startsWith(cmd, "sub ")) {

    a = atoi(cmd + 4);
    b = atoi(cmd + 7);

    intToString(a - b, result);
    printString(result);
}
```

### Implementasi Command Factorial

Command `fac` digunakan untuk menghitung nilai faktorial.

```c
else if (startsWith(cmd, "fac ")) {

    value = atoi(cmd + 4);

    if (value > 8) {
        printString(
            "know your limit little bro."
        );
    } else {

        intToString(
            factorial(value),
            result
        );

        printString(result);
    }
}
```

### Implementasi Command Season

Command `season` digunakan untuk mengubah warna teks menggunakan atribut VGA.

Mode yang tersedia:

* winter
* spring
* summer
* fall
* radiant

### Implementasi Command Triangle

Command `triangle` digunakan untuk mencetak pola segitiga.

```c
else if (startsWith(cmd, "triangle ")) {

    int n = atoi(cmd + 9);

    for (i = 1; i <= n; i++) {

        for (j = 0; j < i; j++) {
            printChar('x');
        }

        newline();
    }
}
```

### Implementasi Command About

Command `about` digunakan untuk menampilkan identitas sistem operasi.

```c
else if (strcmp(cmd, "about")) {
    printString("Farewell Party OS");
}
```

---

## Output

### Tampilan Awal

```text
Welcome to Assistant's Last Gift
type 'help'
```

### Pengujian Command Check

```text
> check
ok
```

### Pengujian Command Help

```text
> help
check add sub fac season triangle clear about
```

### Pengujian Command Add

```text
> add 5 3
8
```

### Pengujian Command Sub

```text
> sub 10 2
8
```

### Pengujian Command Factorial

```text
> fac 6
720
```

### Pengujian Batas Factorial

```text
> fac 120
know your limit little bro.
```

### Pengujian Command Season

```text
> season winter
winter mode

> season spring
spring mode

> season summer
summer mode
```

### Pengujian Command Triangle

```text
> triangle 5

x
xx
xxx
xxxx
xxxxx
```

### Pengujian Command About

```text
> about
Farewell Party OS
```

---

## Problem

* Fungsi `_getChar()` belum diimplementasikan sehingga sistem tidak dapat menerima input keyboard.
* Emulator Bochs pada WSL beberapa kali menampilkan layar hitam meskipun proses build berhasil.
* Bochs sering masuk ke mode debugger sehingga proses pengujian menjadi lebih sulit.
* Penggunaan operator modulo (`%`) menyebabkan linker menghasilkan error `undefined symbol: imod`.
* File `kernel.c` sempat berisi karakter yang tidak dikenali compiler sehingga muncul error `illegal character`.
* Pengujian menggunakan QEMU pada WSL mengalami crash dengan pesan `qemu_mutex_lock_iothread_impl`.
* Parsing command dilakukan secara manual sehingga pemisahan parameter harus menggunakan offset karakter pada string input.

// โหลด Dependencies ที่จำเป็น
const express = require('express')   // ใช้ Express.js เพื่อสร้าง Web Server
const helmet = require('helmet')     // ใช้ Helmet เพื่อเพิ่มความปลอดภัยของ HTTP Headers
const path = require('path');        // 📌 ✅ เพิ่ม path module ที่หายไป!

// สร้างอินสแตนซ์ของ Express.js
const app = express()

// ใช้ Helmet Middleware เพื่อเพิ่มความปลอดภัย
app.use(helmet())

// ใช้ Express Static Middleware ให้โหลดไฟล์ในโฟลเดอร์ `public`
app.use(express.static(path.join(__dirname, 'public')))

// ตั้งค่าพอร์ตและโฮสต์
const hostname = process.env.HOSTNAME || 'localhost'
const port = process.env.PORT || 3002

// 📌 เสิร์ฟไฟล์ `index.html` เมื่อเข้าหน้า `/`
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'))
})

// 📌 เสิร์ฟไฟล์ `hello.html` เมื่อเข้าหน้า `/hello`
app.get('/hello', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'hello.html'))
})

// 📌 หากมีการเข้าเส้นทางอื่น ๆ ที่ไม่มีในระบบ ให้ Redirect กลับไปที่หน้า `/`
app.use((req, res) => {
    res.redirect('/')
})

// เริ่มต้นเซิร์ฟเวอร์
app.listen(port, hostname, () => {
    console.log(`\n🚀 Server running at http://${hostname}:${port}/`)
    console.log(`\n🌍 Try these routes:`)
    console.log(`   ➜ / (Home - index.html)`)
    console.log(`   ➜ /hello (Hello Page - hello.html)`)
    console.log(`\n🛑 Press CTRL+C to stop the server`)
})

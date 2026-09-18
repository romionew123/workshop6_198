import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  // เพิ่มตัวแปรรับค่าเผื่อกรณีที่ส่งข้อมูลมาเพื่อแก้ไข
  final String? documentId;
  final String? fname;
  final String? lname;
  final String? email;
  final String? score;

  const FormScreen({
    super.key,
    this.documentId,
    this.fname,
    this.lname,
    this.email,
    this.score,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // ประกาศตัวแปร Controller สำหรับช่องกรอกข้อมูล
  late TextEditingController fnameController;
  late TextEditingController lnameController;
  late TextEditingController emailController;
  late TextEditingController scoreController;

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // ถ้ามีข้อมูลเก่าส่งมา (โหมดแก้ไข) ให้เอาข้อมูลเดิมมาใส่ช่องกรอกทันที
    fnameController = TextEditingController(text: widget.fname ?? '');
    lnameController = TextEditingController(text: widget.lname ?? '');
    emailController = TextEditingController(text: widget.email ?? '');
    scoreController = TextEditingController(text: widget.score ?? '');
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    emailController.dispose();
    scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId == null ? "บันทึกคะแนน" : "แก้ไขข้อมูลนักเรียน"),
        backgroundColor: const Color.fromARGB(255, 49, 224, 157),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('ชื่อ', style: TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              TextFormField(
                controller: fnameController,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 20),

              const Text('นามสกุล', style: TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              TextFormField(
                controller: lnameController,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกนามสกุล' : null,
              ),
              const SizedBox(height: 20),

              const Text('อีเมล', style: TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              TextFormField(
                controller: emailController,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกอีเมล' : null,
              ),
              const SizedBox(height: 20),

              const Text('คะแนน', style: TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              TextFormField(
                controller: scoreController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกคะแนน' : null,
              ),
              const SizedBox(height: 30),

             ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 49, 224, 157),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.documentId == null) {
                      // กรณีเพิ่มข้อมูลใหม่ (อยู่หน้า Tab หลัก)
                      await _firestore.collection("student").add({
                        "fname": fnameController.text,
                        "lname": lnameController.text,
                        "email": emailController.text,
                        "score": scoreController.text,
                      });

                      // เคลียร์ค่าในฟอร์มให้ว่างหลังจากบันทึกสำเร็จ
                      _formKey.currentState!.reset();
                      fnameController.clear();
                      lnameController.clear();
                      emailController.clear();
                      scoreController.clear();

                      // แสดงข้อความแจ้งเตือนว่าบันทึกสำเร็จ (ไม่ทำให้จอดำ)
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')),
                      );
                    } else {
                      // กรณีแก้ไขข้อมูลเดิม (กดมาจากหน้าลิสต์รายชื่อถึงจะมี documentId)
                      await _firestore.collection("student").doc(widget.documentId).update({
                        "fname": fnameController.text,
                        "lname": lnameController.text,
                        "email": emailController.text,
                        "score": scoreController.text,
                      });

                      if (!mounted) return;
                      Navigator.pop(context); // ปิดหน้าแก้ไขกลับไปหน้าลิสต์
                    }
                  }
                },
                child: Text(
                  widget.documentId == null ? "บันทึก" : "อัปเดต",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
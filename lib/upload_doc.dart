import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UploadBox extends StatefulWidget {
  const UploadBox({super.key});
  @override
  State<UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  PlatformFile? _pickedFile;    // holds picked file metadata + bytes
  Uint8List? _previewBytes;     // image bytes for in-app preview (if image)
  bool _uploading = false;
  String? _uploadResult;        // store server response or error

  // ---- 1) Function: pick file and preview (images & pdf/png allowed) ----
  Future<void> pickFileAndPreview() async {
    // Ask the user to pick a single file of allowed types
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      withData: true,   // load file bytes into memory (needed for preview & upload)
      allowMultiple: false,
    );

    // If user cancelled, result will be null
    if (result == null) return;

    final file = result.files.first;

    // Optional: size validation (here 10 MB limit)
    const maxBytes = 10 * 1024 * 1024;
    if (file.size > maxBytes) {
      setState(() => _uploadResult = 'File too large (max 10MB).');
      return;
    }

    setState(() {
      _pickedFile = file;
      _previewBytes = file.bytes; // will be non-null because withData: true
      _uploadResult = null;
    });
  }

  // ---- 2) Function: upload the picked file to your server ----
  Future<void> uploadPickedFile() async {
  if (_pickedFile == null || _pickedFile!.bytes == null) {
    setState(() => _uploadResult = 'No file selected.');
    return;
  }

  setState(() {
    _uploading = true;
    _uploadResult = null;
  });

  try {
    // 1️⃣ Create a unique file path
    final storageRef = FirebaseStorage.instance.ref().child(
      "uploads/${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}",
    );
    final ext = _pickedFile!.extension?.toLowerCase() ?? '';
    String mimeType = 'application/octet-stream';
    if (ext == 'pdf') mimeType = 'application/pdf';
    if (ext == 'png') mimeType = 'image/png';
    if (ext == 'jpg' || ext == 'jpeg') mimeType = 'image/jpeg';

    // 3️⃣ Upload file bytes
    await storageRef.putData(
      _pickedFile!.bytes!,
      SettableMetadata(contentType: mimeType),
    );

    // 4️⃣ Retrieve file URL
    final url = await storageRef.getDownloadURL();

    setState(() {
      _uploadResult = 'Upload successful!';
      _uploading = false;
    });

    print("Download URL: $url");

  } catch (e) {
    setState(() {
      _uploadResult = 'Upload error: $e';
      _uploading = false;
    });
  }
}


  // Helper to open file externally (optional)
  void openFileExternally() {
    final path = _pickedFile?.path;
    if (path != null) {
      OpenFilex.open(path);
    } else if (_previewBytes != null && _pickedFile != null) {
      // if no path (web or picked with bytes), can't open with OpenFilex; show preview instead
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFileAndPreview,
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.62),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
        ),
        child: _pickedFile == null ? _buildUploadArea() : _buildPreviewArea(),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.upload_outlined, size: 40, color: Colors.grey.shade700),
        const SizedBox(height: 10),
        const Text("Upload your file", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text("Drag and drop or click to browse", style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Text("Supported: .pdf, .png, .jpg (Max 10MB)", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  Widget _buildPreviewArea() {
    final filename = _pickedFile?.name ?? '';
    final ext = _pickedFile?.extension?.toLowerCase() ?? '';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') ...[
            if (_previewBytes != null)
              SizedBox(
                height: 100,
                child: Image.memory(_previewBytes!, fit: BoxFit.contain),
              ),
            const SizedBox(height: 8),
          ] else ...[
            const Icon(Icons.insert_drive_file, size: 56, color: Colors.deepPurple),
            const SizedBox(height: 8),
          ],
          Text(filename, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          if (_uploading) const CircularProgressIndicator(),
          if (!_uploading) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: uploadPickedFile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Upload', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() { _pickedFile = null; _previewBytes = null; _uploadResult = null; }),
                child: const Text('Remove'),
              ),
            ],
          ),
          if (_uploadResult != null) ...[
            const SizedBox(height: 8),
            Text(_uploadResult!, style: TextStyle(color: _uploadResult!.contains('successful') ? Colors.green : Colors.red)),
          ]
        ],
      ),
    );
  }
}

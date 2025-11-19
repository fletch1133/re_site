<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Resume;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ResumeController extends Controller
{
    /**
     * Get the current resume
     */
    public function show()
    {
        $resume = Resume::latest()->first();

        if (!$resume) {
            return response()->json(['message' => 'No resume uploaded'], 404);
        }

        return response()->json($resume);
    }

    /**
     * Upload or update resume
     */
    public function upload(Request $request)
    {
        $request->validate([
            'pdf' => 'required|file|mimes:pdf|max:10240', // 10MB max, PDF only for browser preview
        ]);

        $pdf = $request->file('pdf');
        $pdfPath = $pdf->store('resume', 'public');

        // Delete old resume if exists
        $oldResume = Resume::latest()->first();
        if ($oldResume) {
            Storage::disk('public')->delete($oldResume->pdf_path);
            $oldResume->delete();
        }

        $resume = Resume::create([
            'pdf_path' => $pdfPath,
            'pdf_original_name' => $pdf->getClientOriginalName(),
            'pdf_size' => $pdf->getSize(),
        ]);

        return response()->json($resume, 201);
    }
}

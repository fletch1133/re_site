<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Project;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProjectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $projects = Project::where('is_published', true)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($projects);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'required|in:single_family,multi_family_commercial,land_entitlements',
            'pdf' => 'required|file|mimes:pdf,xlsx,xls|max:10240', // 10MB max - Pro Forma (PDF or Excel)
            'summary_pdf' => 'nullable|file|mimes:pdf|max:10240', // 10MB max - Summary
            'is_published' => 'boolean',
        ]);

        $pdf = $request->file('pdf');
        $pdfPath = $pdf->store('projects', 'public');

        $projectData = [
            'title' => $request->title,
            'description' => $request->description,
            'category' => $request->category,
            'pdf_path' => $pdfPath,
            'pdf_original_name' => $pdf->getClientOriginalName(),
            'pdf_size' => $pdf->getSize(),
            'is_published' => $request->is_published ?? true,
        ];

        // Handle summary PDF if provided
        if ($request->hasFile('summary_pdf')) {
            $summaryPdf = $request->file('summary_pdf');
            $summaryPdfPath = $summaryPdf->store('projects', 'public');
            $projectData['summary_pdf_path'] = $summaryPdfPath;
            $projectData['summary_pdf_original_name'] = $summaryPdf->getClientOriginalName();
            $projectData['summary_pdf_size'] = $summaryPdf->getSize();
        }

        $project = Project::create($projectData);

        return response()->json($project, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $project = Project::findOrFail($id);
        return response()->json($project);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $project = Project::findOrFail($id);

        $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'category' => 'sometimes|in:single_family,multi_family_commercial,land_entitlements',
            'pdf' => 'sometimes|file|mimes:pdf,xlsx,xls|max:10240', // Pro Forma (PDF or Excel)
            'summary_pdf' => 'nullable|file|mimes:pdf|max:10240',
            'is_published' => 'boolean',
        ]);

        if ($request->hasFile('pdf')) {
            // Delete old PDF
            Storage::disk('public')->delete($project->pdf_path);

            $pdf = $request->file('pdf');
            $pdfPath = $pdf->store('projects', 'public');

            $project->pdf_path = $pdfPath;
            $project->pdf_original_name = $pdf->getClientOriginalName();
            $project->pdf_size = $pdf->getSize();
        }

        // Handle summary PDF
        if ($request->hasFile('summary_pdf')) {
            // Delete old summary PDF if exists
            if ($project->summary_pdf_path) {
                Storage::disk('public')->delete($project->summary_pdf_path);
            }

            $summaryPdf = $request->file('summary_pdf');
            $summaryPdfPath = $summaryPdf->store('projects', 'public');

            $project->summary_pdf_path = $summaryPdfPath;
            $project->summary_pdf_original_name = $summaryPdf->getClientOriginalName();
            $project->summary_pdf_size = $summaryPdf->getSize();
        }

        $project->fill($request->only(['title', 'description', 'category', 'is_published']));
        $project->save();

        return response()->json($project);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $project = Project::findOrFail($id);

        // Delete PDF files
        Storage::disk('public')->delete($project->pdf_path);
        if ($project->summary_pdf_path) {
            Storage::disk('public')->delete($project->summary_pdf_path);
        }

        $project->delete();

        return response()->json(['message' => 'Project deleted successfully']);
    }
}

<?php

namespace App\Http\Controllers\customer;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Services\OpenAIService;
use Illuminate\Http\Request;

class ConsultAIController extends Controller
{
    protected $aiService;

    public function __construct(OpenAIService $aiService)
    {
        $this->aiService = $aiService;
    }

    public function consult(Request $request)
    {
        // Validate the request input
        $request->validate([
            'question' => 'required|string',
        ]);
      $question = $request->input('question');
        $categories = Category::with('vendors.products')->get();
        // Generate the answer using the AI service
        $answer = $this->aiService->generateAnswer($question, $categories);

        return response()->json(['status' => 'success', 'answer' => $answer]);
    }
  
}

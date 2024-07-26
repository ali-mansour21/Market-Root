<?php

namespace App\Services;

use GuzzleHttp\Client;
use OpenAI\Laravel\Facades\OpenAI;

class OpenAIService
{
    protected $client;
    protected $apiKey;

    public function __construct()
    {
        $this->client = new Client();
        $this->apiKey = env('OPENAI_API_KEY');
    }

    /**
     * Send a query and context to OpenAI to generate an answer.
     *
     * @param string $context Context or content from the PDF as background information.
     * @param string $question The user's question.
     * @return string The answer from OpenAI.
     */
    public function generateAnswer($question, $categories)
    {
        $messages = [];

        // Create a dataset context from categories
        $datasetContext = $this->createDatasetContext($categories);

        if (!empty($datasetContext)) {
            $messages[] = ['role' => 'system', 'content' => $datasetContext];
        }

        $messages[] = ['role' => 'user', 'content' => $question];

        $response = OpenAI::chat()->create([
            'model' => 'gpt-4',
            'messages' => $messages,
        ]);

        return $response->choices[0]->message->content;
    }

    private function createDatasetContext($categories)
    {
        $datasetContext = "Here is the list of available categories, shops, and products:\n";

        foreach ($categories as $category) {
            $datasetContext .= "Category: {$category['title']}\n";
            if (!empty($category['vendors'])) {
                foreach ($category['vendors'] as $vendor) {
                    $datasetContext .= "  Shop: {$vendor['name']}\n";
                    if (!empty($vendor['products'])) {
                        // Convert the products collection to an array
                        $productsArray = $vendor['products']->toArray();
                        $datasetContext .= "    Products: " . implode(', ', array_column($productsArray, 'name')) . "\n";
                    } else {
                        $datasetContext .= "    Products: No products available\n";
                    }
                }
            } else {
                $datasetContext .= "  Vendors: No vendors available\n";
            }
        }

        return $datasetContext;
    }
}

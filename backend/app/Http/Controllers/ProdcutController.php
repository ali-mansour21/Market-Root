<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ProdcutController extends Controller
{
    public function index(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'min:2', 'max:255'],
            'price' => ['required', 'numeric', 'min:4'],
            'vendor_id' => ['required', Rule::exists('vendors', 'vendor_id')],
            'product_image' => ['required', 'image', 'mimes:jpeg,png,jpg,gif', 'max:2048']
        ]);
        if ($request->hasFile('product_image')) {
            $product_image = $request->file('product_image');
            $product_image_name = time() . '_' . $product_image->getClientOriginalName();
            $product_image_path = $product_image->storeAs('vendor/products', $product_image_name, 'public');
        }
        $product = new Product();
        $product->name = $validated['name'];
        $product->price = $validated['price'];
        $product->vendor_id = $validated['vendor_id'];
        $product->product_image = $product_image_path;
        $product->save();
        return response()->json(['message' => 'Product created successfully'], 201);
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Vendor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class HomeController extends Controller
{
    public function index()
    {
        $data = Category::with('vendors.products')->get();
        return response()->json(['status' => 'success', 'data' => $data]);
    }
    public function searchVendorByName(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
        ]);

        $name = $request->input('name');

        $cacheKey = 'vendor_search_' . strtolower($name);

        $vendor = Cache::get($cacheKey);

        if (!$vendor) {
            $vendor = Vendor::where('name', 'LIKE', '%' . $name . '%')->get();

            Cache::put($cacheKey, $vendor, 60);
        }

        return response()->json($vendor);
    }
}

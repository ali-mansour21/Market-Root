<?php

namespace App\Http\Controllers\customer;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\User;
use App\Models\UserAdress;
use App\Models\Vendor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rule;

class CustomerController extends Controller
{
    public function get_orders()
    {
        $user_id = auth()->id();

        // Retrieve orders with order items and vendor relationships
        $orders = Order::where('user_id', $user_id)
            ->with('order_items', 'vendor')
            ->get();

        // Group orders by status
        $pending_orders = $orders->where('status', 'pending');
        $confirmed_or_canceled_orders = $orders->whereIn('status', ['confirmed', 'canceled']);

        // Prepare the response
        return response()->json([
            'status' => 'success',
            'data' => [
                'pending_orders' => $pending_orders,
                'confirmed_or_canceled_orders' => $confirmed_or_canceled_orders,
            ]
        ]);
    }

    public function create_order(Request $request)
    {
        $request->validate([
            'vendor_id' => 'required|exists:vendors,vendor_id',
            'total_price' => 'required|numeric',
            'order_items' => 'required|array',
            'order_items.*.product_id' => 'required|exists:products,product_id',
            'order_items.*.price' => 'required|numeric',
            'order_items.*.quantity' => 'required|integer'
        ]);
        $user_id = auth()->id();
        $order = Order::create([
            'vendor_id' => $request->vendor_id,
            'user_id' => $user_id,
            'total_price' => $request->total_price,
            'status' => 'pending',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        foreach ($request->order_items as $item) {
            OrderItem::create([
                'order_id' => $order->id,
                'product_id' => $item['product_id'],
                'price' => $item['price'],
                'quantity' => $item['quantity'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        return response()->json(['message' => 'Order created successfully!'], 201);
    }
    public function index(Request $request)
    {
        $data = $request->validate([
            'username' => ['required', 'string', 'min:2', 'max:255'],
            'email' => ['required', 'email', Rule::unique('users', 'dbemail')],
            'password' => ['required', 'min:6', 'max:16'],
            'phone_number' => ['required'],
            'city' => ['required', 'string'],
            'street' => ['required', 'string']
        ]);
        $user = new User();
        $user->username = $data['username'];
        $user->dbemail = $data['email'];
        $user->dbpassword =  password_hash($data['password'], PASSWORD_DEFAULT);
        $user->phone_number = $request->phone_number;
        $user->dbtype = 'customer';
        $user->save();
        try {
            UserAdress::create([
                'user_id' => $user->id,
                'city' => $data['city'],
                'street' => $data['street'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } catch (\Exception $e) {
            Log::error('Error creating user address: ' . $e->getMessage());
        }
        $token = Auth::login($user);
        return response()->json([
            'status' => 'success',
            'message' => 'User created successfully',
            'user' => $user,
            'authorization' => [
                'token' => $token,
                'type' => 'bearer',
            ]
        ]);
    }
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        $token = Auth::attempt($credentials);
        if (!$token) {
            return response()->json([
                'status' => 'error',
                'message' => 'Unauthorized',
            ], 401);
        }
        // $user = Auth::user();
        return response()->json([
            'status' => 'success',

            'authorization' => [
                'token' => $token,
                'type' => 'bearer',
            ]
        ], 200);
    }
}

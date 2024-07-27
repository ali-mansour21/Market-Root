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
use Illuminate\Validation\Rule;

class CustomerController extends Controller
{
    public function createOrder(Request $request)
    {
        $request->validate([
            'vendor_id' => 'required|exists:vendors,id',
            'user_id' => 'required|exists:users,id',
            'total_price' => 'required|numeric',
            'order_items' => 'required|array',
            'order_items.*.product_id' => 'required|exists:products,id',
            'order_items.*.price' => 'required|numeric',
            'order_items.*.quantity' => 'required|integer'
        ]);

        $order = Order::create([
            'vendor_id' => $request->vendor_id,
            'user_id' => $request->user_id,
            'total_price' => $request->total_price,
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
        $user->email = $data['email'];
        $user->password =  password_hash($data['password'], PASSWORD_DEFAULT);
        $user->phone_number = $request->phone_number;
        $user->dbtype = 'customer';
        $user->save();
        UserAdress::create([
            'user_id' => $user->id,
            'city' => $data['city'],
            'street' => $data['street'],
        ]);
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

<?php

namespace App\Http\Controllers\customer;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserAdress;
use App\Models\Vendor;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CustomerController extends Controller
{
    public function index(Request $request)
    {
        $data = $request->validate([
            'username' => ['required', 'string', 'min:2', 'max:255'],
            'email' => ['required', 'email', Rule::unique('users', 'dbemail')],
            'password' => ['required', 'min:6', 'max:16'],
            'phone_number' => ['required', 'digits:8'],
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
        UserAdress::create([
            'user_id' => $user->id,
            'city' => $data['city'],
            'street' => $data['street']
        ]);
        return response()->json(['message' => 'User created successfully'], 201);
    }
    public function vendor(Request $request)
    {
        $data = $request->validate([
            'category_id' => ['required', Rule::exists('categories', 'category_id')],
            'user_id' => ['required', Rule::exists('users', 'user_id')],
            'name' => ['required', 'string'],
            'logo' => ['required', 'image', 'mimes:jpeg,png,jpg,gif', 'max:2048']
        ]);
        if ($request->hasFile('logo')) {
            $logo = $request->file('logo');
            $logoName = time() . '_' . $logo->getClientOriginalName();
            $logoPath = $logo->storeAs('vendor/logos', $logoName, 'public');
        }
        $shop = new Vendor([
            'category_id' => $data['category_id'],
            'user_id' => $data['user_id'],
            'name' => $data['name'],
            'logo' => $logoPath,
            'Status' => 'accepted'
        ]);

        $shop->save();
        return response()->json(['message' => 'Vendor created successfully'], 201);
    }
}

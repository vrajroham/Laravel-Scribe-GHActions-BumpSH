<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::group(['prefix' => 'post'], function () {
    Route::get('/', 'App\Http\Controllers\PostController@index');
    Route::get('/{id}', 'App\Http\Controllers\PostController@show');
    Route::post('/', 'App\Http\Controllers\PostController@store');
    Route::put('/{id}', 'App\Http\Controllers\PostController@update');
    Route::delete('/{id}', 'App\Http\Controllers\PostController@destroy');
    Route::get('/test', 'App\Http\Controllers\PostController@test');
    Route::post('/test-endpoint', 'App\Http\Controllers\PostController@test');
});

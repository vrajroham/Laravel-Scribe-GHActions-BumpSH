<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PostController extends Controller
{
    /**
     * All posts
     *
     * @return string
     */
    public function index()
    {
        return "post index";
    }

    /**
     * Show post
     *
     * @param int $id
     * @return string
     */
    public function show($id)
    {
        return "post show";
    }

    /**
     * Store post
     *
     * @param Request $request
     * @return string
     */
    public function store(Request $request)
    {
        return "post store";
    }

    /**
     * Update post
     *
     * @param Request $request
     * @param int $id
     * @return string
     */
    public function update(Request $request, $id)
    {
        return "post update";
    }

    /**
     * Delete post
     *
     * @param int $id
     * @return string
     */
    public function destroy($id)
    {
        return "post destroy";
    }

}

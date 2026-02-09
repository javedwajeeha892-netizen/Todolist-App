<?php
// test_backend.php

function callAPI($method, $url, $data = false)
{
    $curl = curl_init();
    $url = "http://localhost:8000/" . $url;

    switch ($method) {
        case "POST":
            curl_setopt($curl, CURLOPT_POST, 1);
            if ($data)
                curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
            break;
        case "GET":
            if ($data)
                $url = sprintf("%s?%s", $url, http_build_query($data));
            break;
        // ... put/patch/delete as needed
    }

    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

    // Header
    curl_setopt($curl, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json'
    ]);

    $result = curl_exec($curl);
    curl_close($curl);
    return json_decode($result, true);
}

echo "1. Testing Signup...\n";
$signup = callAPI('POST', 'auth.php?action=signup', ['username' => 'testuser', 'password' => '123456']);
print_r($signup);

echo "\n2. Testing Login...\n";
$login = callAPI('POST', 'auth.php?action=login', ['username' => 'testuser', 'password' => '123456']);
print_r($login);

if ($login['success']) {
    $userId = $login['user']['id'];

    echo "\n3. Adding Task...\n";
    $addTask = callAPI('POST', "tasks.php?user_id=$userId", ['title' => 'Test Task 1']);
    print_r($addTask);

    echo "\n4. Fetching Tasks...\n";
    $tasks = callAPI('GET', "tasks.php", ['user_id' => $userId]);
    print_r($tasks);
} else {
    echo "Login failed, skipping task tests.\n";
}
?>
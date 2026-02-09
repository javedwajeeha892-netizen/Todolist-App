<?php
// backend/tasks.php
header('Content-Type: application/json');
require 'db.php';

$method = $_SERVER['REQUEST_METHOD'];
$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(['success' => false, 'message' => 'User ID required']);
    exit;
}

if ($method === 'GET') {
    // Fetch tasks for user
    $stmt = $pdo->prepare("SELECT * FROM tasks WHERE user_id = ? ORDER BY created_at DESC");
    $stmt->execute([$user_id]);
    $tasks = $stmt->fetchAll();
    echo json_encode(['success' => true, 'tasks' => $tasks]);

} elseif ($method === 'POST') {
    // Add new task
    $data = json_decode(file_get_contents('php://input'), true);
    $title = $data['title'] ?? '';

    if ($title) {
        $stmt = $pdo->prepare("INSERT INTO tasks (user_id, title) VALUES (?, ?)");
        $stmt->execute([$user_id, $title]);
        echo json_encode(['success' => true, 'message' => 'Task added', 'id' => $pdo->lastInsertId()]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Title required']);
    }

} elseif ($method === 'PATCH') {
    // Update task (toggle status)
    $data = json_decode(file_get_contents('php://input'), true);
    $task_id = $data['id'] ?? null;
    $is_completed = $data['is_completed'] ?? 0;

    if ($task_id) {
        $stmt = $pdo->prepare("UPDATE tasks SET is_completed = ? WHERE id = ? AND user_id = ?");
        $stmt->execute([$is_completed, $task_id, $user_id]);
        echo json_encode(['success' => true, 'message' => 'Task updated']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Task ID required']);
    }

} elseif ($method === 'DELETE') {
    // Delete task
    $task_id = $_GET['id'] ?? null;

    if ($task_id) {
        $stmt = $pdo->prepare("DELETE FROM tasks WHERE id = ? AND user_id = ?");
        $stmt->execute([$task_id, $user_id]);
        echo json_encode(['success' => true, 'message' => 'Task deleted']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Task ID required']);
    }
}
?>
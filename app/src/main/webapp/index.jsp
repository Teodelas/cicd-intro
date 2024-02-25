<%@ page
        language="java"
        contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>

<html>
<head>
<style>
h1 {text-align: center;}
p {text-align: center;}
div {text-align: center;}
</style>
</head>
<body>

<h1>Attack Path Lab</h1>
<p>This is Attack Path Testing Lab Vulnerable Application. Updated</p>
<div>Sample exploitable application.
<s:a id="%{id}">your input id: ${id}
</s:a>
<p style="text-align:center;"><img src="./img.png" alt="Logo"></p>
<p>output :</p>
<p id="output"></p>
</div>
<script>
        let id = document.getElementsByTagName("a")[0].id;
        document.getElementById("output").innerHTML = id;
</script>
</body>
</html>

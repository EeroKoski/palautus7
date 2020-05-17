<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<script src="scripts/main.js"></script>

<title>Asiakaslista</title>
<style>
.vasen{
		text-align:left;
		}
</style>
</head>
<body onkeydown="tutkiKey(event)">
<table id="listaus">
	<thead>		
		
	<tr>
	<th colspan="5" id="ilmo"></th>
	<th><a id="uusiAsiakas" href="lisaaasiakas.jsp">Lisää uusi asiakastieto</a></th>	</tr>
	
	<tr>
	<th class="vasen">Hakusana: </th>
	<th colspan="4"><input type="text" id="hakusana"></th>
	<th class="vasen"><input type="button" value="Hae" id="hakunappi" onclick="haeTiedot()"></th>
	</tr>
		
		<tr>
 		<th>Asiakas ID</th>
 		<th>Etunimi</th>
 		<th>Sukunimi</th>
 		<th>Puhelinnumero</th>
 		<th>Sähköposti</th>
 		<th> </th>
		</tr>
		</thead>
		 		
		 <tbody id="tbody">		 
		 </tbody>
</table>

<script>
haeTiedot();	
document.getElementById("hakusana").focus();

function tutkiKey(event){
	if(event.keyCode==13){
		haeTiedot();
	}		
}

function haeTiedot(){	
	document.getElementById("tbody").innerHTML = "";
	fetch("asiakkaat/" + document.getElementById("hakusana").value,{//Lähetetään kutsu backendiin
	      method: 'GET'
	    })
	.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json()	
	})
	.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
		var asiakkaat = responseJson.asiakkaat;	
		var htmlStr="";
		for(var i=0;i<asiakkaat.length;i++){			
        	htmlStr+="<tr>";
        	htmlStr+="<td>"+asiakkaat[i].asiakas_id+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>"; 
        	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";  
        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;";
        	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
        
        	htmlStr+="</tr>";        	
		}
		document.getElementById("tbody").innerHTML = htmlStr;		
	})	
}

function poista(asiakas_id){
	if(confirm("Poista asiakas " + asiakas_id +"?")){	
		fetch("asiakkaat/"+ asiakas_id,{//Lähetetään kutsu backendiin
		      method: 'DELETE'		      	      
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Asiakastiedon poisto epäonnistui.";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML="Asiakastiedon " + asiakas_id +" poisto onnistui.";
				haeTiedot();        	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		})		
	}	
}
</script>
</body>
</html>
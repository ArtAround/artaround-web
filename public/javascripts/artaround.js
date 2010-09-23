$(document).ready(function(){
	$("#editInformation a").toggle(
		function(){
			$("#artworkMetaData").hide();
			$("#edit_artworkMetaData").show();
			$(".callout").hide();
	  	},
	  	function(){
  	     	$("#artworkMetaData").show();
			$("#edit_artworkMetaData").hide();
			$(".callout").show();
  	  	} 
	);
	
	$(".hideCategory").click(
		function(){
			$("#categoryScroll").slideUp();
			$(".hideCategory").hide();
			$(".showCategory").show();
			return false;
	  	}
	);
	
	$(".hideNeighborhood").click(
		function(){
			$("#neighborhoodScroll").slideUp();
			$(".hideNeighborhood").hide();
			$(".showNeighborhood").show();
			return false;
	  	}
	);
	
	$(".showCategory").click(
		function(){
			$("#categoryScroll").slideDown();
			$(".showCategory").hide();
			$(".hideCategory").show();
			return false;
	  	}
	);
	
	$(".showNeighborhood").click(
		function(){
			$("#neighborhoodScroll").slideDown();
			$(".showNeighborhood").hide();
			$(".hideNeighborhood").show();
			return false;
	  	}
	);
	
	$(".cancelBtn").click(
		function(){
			$("#artworkMetaData").show();
			$("#edit_artworkMetaData").hide();
			$(".callout").show();
			return false;
	  	}
	);
});
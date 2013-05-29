/*jslint browser: true, indent: 2, plusplus: true */
/*global google, $*/
(function(){"use strict";function e(t){var n,r,i,s;if(null===t||"object"!=typeof t)return t;if(t instanceof Date)return n=new Date,n.setTime(t.getTime()),n;if(t instanceof Array){n=[];for(r=0,s=t.length;r<s;r++)n[r]=e(t[r]);return n}if(t instanceof Object){n={};for(i in t)t.hasOwnProperty(i)&&(n[i]=e(t[i]));return n}throw new Error("Unable to copy obj! Its type isn't supported.")}function r(e){var r,i,s,o,u,a,f,l,c,h,p;h=Object.prototype.toString.call(e);if(h==="[object Date]")return e;if(h!=="[object String]")return;if(s=e.match(t))return p=parseInt(s[1],10),a=parseInt(s[3],10)-1,r=parseInt(s[5],10),i=parseInt(s[7],10),u=s[9]?parseInt(s[9],10):0,c=s[11]?parseInt(s[11],10):0,o=s[12]?parseFloat(n+s[12].slice(1))*1e3:0,l=Date.UTC(p,a,r,i,u,c,o),s[13]&&s[14]&&(f=s[15]*60,s[17]&&(f+=parseInt(s[17],10)),f*=s[14]==="-"?-1:1,l-=f*60*1e3),new Date(l)}function h(e,t){document.body.innerText?e.innerText=t:e.textContent=t}function p(e,t){h(e,"Error Loading Chart: "+t),e.style.color="#ff0000"}function d(e,t,n){$.ajax({dataType:"json",url:t,success:n,error:function(t,n,r){var i=typeof r=="string"?r:r.message;p(e,i)}})}function v(e,t,n,r){try{r(e,t,n)}catch(i){throw p(e,i.message),i}}function m(e,t,n,r){typeof t=="string"?d(e,t,function(t,i,s){v(e,t,n,r)}):v(e,t,n,r)}function g(e){return Object.prototype.toString.call(e)==="[object Array]"}function y(e){return""+e}function b(e){return parseFloat(e)}function w(e){if(typeof e!="object")if(typeof e=="number")e=new Date(e*1e3);else{var t=e.replace(/ /,"T").replace(" ","").replace("UTC","Z");e=r(t)||new Date(e)}return e}function E(e){if(!g(e)){var t=[],n;for(n in e)e.hasOwnProperty(n)&&t.push([n,e[n]]);e=t}return e}function S(e,t){return e[0].getTime()-t[0].getTime()}function x(e,t){var n,r,i,s,o;if(!g(e)||typeof e[0]!="object"||g(e[0]))e=[{name:"Value",data:e}];for(n=0;n<e.length;n++){i=E(e[n].data),s=[];for(r=0;r<i.length;r++)o=i[r][0],o=t?w(o):y(o),s.push([o,b(i[r][1])]);t&&s.sort(S),e[n].data=s}return e}function T(e,t,n){i(e,x(t,!0),n)}function N(e,t,n){o(e,x(t,!1),n)}function C(e,t,n){var r=E(t),i;for(i=0;i<r.length;i++)r[i]=[y(r[i][0]),b(r[i][1])];s(e,r,n)}var t=/(\d\d\d\d)(\-)?(\d\d)(\-)?(\d\d)(T)?(\d\d)(:)?(\d\d)?(:)?(\d\d)?([\.,]\d+)?($|Z|([\+\-])(\d\d)(:)?(\d\d)?)/i,n=String(1.5).charAt(1),i,s,o;if("Highcharts"in window){var u={xAxis:{labels:{style:{fontSize:"12px"}}},yAxis:{title:{text:null},labels:{style:{fontSize:"12px"}},min:0},title:{text:null},credits:{enabled:!1},legend:{borderWidth:0},tooltip:{style:{fontSize:"12px"}}},a=function(t){var n=e(u);return"min"in t&&(n.yAxis.min=t.min),"max"in t&&(n.yAxis.max=t.max),n};i=function(e,t,n){var r=a(n),i,s,o;r.xAxis.type="datetime",r.chart={type:"spline"};for(s=0;s<t.length;s++){i=t[s].data;for(o=0;o<i.length;o++)i[o][0]=i[o][0].getTime();t[s].marker={symbol:"circle"}}r.series=t,t.length===1&&(r.legend={enabled:!1}),$(e).highcharts(r)},s=function(e,t,n){var r=a(n);r.series=[{type:"pie",name:"Value",data:t}],$(e).highcharts(r)},o=function(e,t,n){var r=a(n),i,s,o,u,f=[];r.chart={type:"column"};for(i=0;i<t.length;i++){o=t[i];for(s=0;s<o.data.length;s++)u=o.data[s],f[u[0]]||(f[u[0]]=new Array(t.length)),f[u[0]][i]=u[1]}var l=[];for(i in f)f.hasOwnProperty(i)&&l.push(i);r.xAxis.categories=l;var c=[];for(i=0;i<t.length;i++){u=[];for(s=0;s<l.length;s++)u.push(f[l[s]][i]);c.push({name:t[i].name,data:u})}r.series=c,t.length===1&&(r.legend.enabled=!1),$(e).highcharts(r)}}else if("google"in window){var f=!1;google.setOnLoadCallback(function(){f=!0}),google.load("visualization","1.0",{packages:["corechart"]});var l=function(e){google.setOnLoadCallback(e),f&&e()},u={fontName:"'Lucida Grande', 'Lucida Sans Unicode', Verdana, Arial, Helvetica, sans-serif",pointSize:6,legend:{textStyle:{fontSize:12,color:"#444"},alignment:"center",position:"right"},curveType:"function",hAxis:{textStyle:{color:"#666",fontSize:12},gridlines:{color:"transparent"},baselineColor:"#ccc"},vAxis:{textStyle:{color:"#666",fontSize:12},baselineColor:"#ccc",viewWindow:{min:0}},tooltip:{textStyle:{color:"#666",fontSize:12}}},c=function(e,t){var n=new google.visualization.DataTable;n.addColumn(t,"");var r,i,s,o,u,a=[];for(r=0;r<e.length;r++){s=e[r],n.addColumn("number",s.name);for(i=0;i<s.data.length;i++)o=s.data[i],u=t==="datetime"?o[0].getTime():o[0],a[u]||(a[u]=new Array(e.length)),a[u][r]=b(o[1])}var f=[];for(r in a)a.hasOwnProperty(r)&&f.push([t==="datetime"?new Date(b(r)):r].concat(a[r]));return n.addRows(f),n},a=function(t){var n=e(u);return"min"in t&&(n.vAxis.viewWindow.min=t.min),"max"in t&&(n.vAxis.viewWindow.max=t.max),n};i=function(e,t,n){l(function(){var r=c(t,"datetime"),i=a(n);t.length===1&&(i.legend.position="none");var s=new google.visualization.LineChart(e);s.draw(r,i)})},s=function(e,t,n){l(function(){var r=new google.visualization.DataTable;r.addColumn("string",""),r.addColumn("number","Value"),r.addRows(t);var i=a(n);i.chartArea={top:"10%",height:"80%"};var s=new google.visualization.PieChart(e);s.draw(r,i)})},o=function(e,t,n){l(function(){var r=c(t,"string"),i=a(n);t.length===1&&(i.legend.position="none");var s=new google.visualization.ColumnChart(e);s.draw(r,i)})}}else i=s=o=function(){throw new Error("Please install Google Charts or Highcharts")};var k={LineChart:function(e,t,n){m(e,t,n||{},T)},ColumnChart:function(e,t,n){m(e,t,n||{},N)},PieChart:function(e,t,n){m(e,t,n||{},C)}};window.Chartkick=k})();
# NIMBUX911 - Ejercicio AWS + TF

<p>&nbsp;</p>

<p><span style="font-size:16px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Acerca del repositorio</strong></span></span></p>

<p><span style="font-size:16px">El presente repositorio contiene c&oacute;digo Terraform para el despliegue de infraestructura sobre AWS de acuerdo a la consigna acercada oportunamente.</span></p>

<p>&nbsp;</p>

<p><span style="font-size:16px"><strong><span style="font-family:Arial,Helvetica,sans-serif">Descripci&oacute;n del contenido</span></strong></span></p>

<p><span style="font-size:16px">Se ha distribuido el c&oacute;digo, salidas, declaraci&oacute;n de variables y definici&oacute;n de valores para las mismas en los siguientes archivos de acuerdo a est&aacute;ndar TF.</span></p>

<ul>
	<li><span style="font-size:16px"><em>main.tf&nbsp;</em></span></li>
	<li><span style="font-size:16px"><em>variable.tf</em></span></li>
	<li><span style="font-size:16px"><em>output.tf</em></span></li>
	<li><span style="font-size:16px"><em>terraform.tfvars</em></span></li>
</ul>

<p>&nbsp;</p>

<p><span style="font-size:16px">Adicionalmente el c&oacute;digo referencia a los siguientes scripts que contienen el c&oacute;digo requerido para la instalaci&oacute;n de servidores web (APACHE + NGINX) sobre las instancias EC2 a disponibilizar.</span></p>

<ul>
	<li><span style="font-size:16px">install_wsrv_1.sh</span></li>
	<li><span style="font-size:16px">install_wsrv_2.sh &nbsp;</span></li>
</ul>

<p>&nbsp;</p>

<p><span style="font-size:16px"><strong><span style="font-family:Arial,Helvetica,sans-serif">Variables&nbsp;</span></strong></span></p>

<p><span style="font-size:16px"><span style="font-family:Arial,Helvetica,sans-serif">A continuaci&oacute;n se brinda detalle de las variables declaradas para las cuales el c&oacute;digo TF espera valores, los mismos se encuentra definidos en el archivo terraform.tfvars, </span></span><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>a excepci&oacute;n de provider_access_key y provider_secret_key para las cuales no se expone valor por tratarse de informaci&oacute;n sensible [credenciales].</em></span></span></p>

<p>&nbsp;</p>

<table align="left" border="1" cellpadding="1" cellspacing="1" style="width:1118px">
	<thead>
		<tr>
			<th scope="col" style="width:211px"><span style="font-size:16px"><strong>VARIABLE</strong></span></th>
			<th scope="col" style="width:78px"><span style="font-size:16px"><strong>TIPO</strong></span></th>
			<th scope="col" style="width: 554px;"><span style="font-size:16px">DETALLE</span></th>
			<th scope="col" style="width: 228px;"><span style="font-size:16px">VALOR POR DEFECTO</span></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="width:211px"><span style="font-size:16px">provider_access_key</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Access key ID de usuario AWS</span></td>
			<td style="text-align:center; width:228px">&nbsp;</td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">provider_secret_key</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Secret access key de usuario AWS</span></td>
			<td style="text-align:center; width:228px">&nbsp;</td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">provider_region</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Regi&oacute;n AWS sobre la cual se realizaran acciones</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">us-east-1</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">vpc_cidr_block&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Bloque de direccionamiento IP para VPC</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">10.0.0.0/16</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">availability_zone_1&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Primer zona de disponibilidad AWS [AZ 1] sobre la cual se despleg&aacute; subred p&uacute;blica/privada, instancia EC2 y NAT Gateway&nbsp;</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">us-east-1a</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">pub_snet_1_cidr_block&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Bloque de direccionamiento IP para subred p&uacute;blica en AZ 1</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">10.0.1.0/24</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">prv_snet_1_cidr_block&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Bloque de direccionamiento IP para subred privada en AZ 1</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">10.0.2.0/24</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">availability_zone_2&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Segunda zona de disponibilidad AWS [AZ 2] sobre la cual se despleg&aacute; subred p&uacute;blica/privada, instancia EC2 y NAT Gateway&nbsp;</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">us-east-1b</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">pub_snet_2_cidr_block&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Bloque de direccionamiento IP para subred p&uacute;blica en AZ 2</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">10.0.3.0/24</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">prv_snet_2_cidr_block&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Bloque de direccionamiento IP para subred privada en AZ 1</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">10.0.4.0/24</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">instance_ami&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">C&oacute;digo AMI (Amazon Machine Image) para instancias EC2 a desplegar</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">ami-08c40ec9ead489470</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">instance_type&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Tipo de instancias EC2 a desplegar</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">t2.micro</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">instance_ec2_wsrv_1_tag_name&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Etiqueta &quot;nombre&quot; para instancia EC2 en AZ 1&nbsp;</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">EC2-WSRV-NGINX-1</span></td>
		</tr>
		<tr>
			<td style="width:211px"><span style="font-size:16px">instance_ec2_wsrv_2_tag_name&nbsp;</span></td>
			<td style="text-align:center; width:78px"><span style="font-size:16px">string</span></td>
			<td style="text-align:center; width:554px"><span style="font-size:16px">Etiqueta &quot;nombre&quot; para instancia EC2 en AZ 2</span></td>
			<td style="text-align:center; width:228px"><span style="font-size:16px">EC2-WSRV-APACHE-1</span></td>
		</tr>
	</tbody>
</table>

<p>&nbsp;</p>

<p><strong><span style="font-size:16px"><span style="font-family:Arial,Helvetica,sans-serif">Arquitectura de soluci&oacute;n</span></span></strong></p>

<p>A continuaci&oacute;n se adjunta diagrama de arquitectura de la soluci&oacute;n propuesta graficando componentes y comunicaciones, adicionalmente se a&ntilde;ade detalle de par&aacute;metros considerados de relevancia a fin de facilitar entendimiento del dise&ntilde;o.</p>

<p>&nbsp;</p>

<img src="https://i.im.ge/2022/10/13/2OV9e9.Diagrama-ARQ-Completo.jpg" alt="Diagrama_ARQ_Completo" border="0">

<p>&nbsp;</p>

<p><strong><span style="font-size:16px"><span style="font-family:Arial,Helvetica,sans-serif">Versiones</span></span></strong></p>

<p>Para el siguiente ejercicio pr&aacute;ctico se ha utilizado Terraform v1.3.1</p>

<p>&nbsp;</p>


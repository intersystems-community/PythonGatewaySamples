Class ml.engine.Installer
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <Default Name="NAMESPACE" Value="${NAMESPACE}"/>
  <Default Name="DBNAME" Value="${NAMESPACE}"/>
  <Default Name="RESOURCE" Value="%DB_${DBNAME}" /> 
  <Namespace Name="${NAMESPACE}" Code="${DBNAME}" Data="${DBNAME}" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="${DBNAME}" Dir="${MGRDIR}${DBNAME}" Create="yes" Resource="${RESOURCE}"/>
    </Configuration>

    <Import File="${SOURCESPATH}" Recurse="1"/>
    
    <Log Level="1" Text="Configuring Production"/>
    <Invoke Class="ml.engine.Installer" Method="ConfigureProduction" CheckStatus="true"/>
  </Namespace>
  
  <User Username="${NAMESPACE}" Namespace="${Namespace}" PasswordVar="NAMESPACE" Roles="${RESOURCE},%DB_%DEFAULT,%EnsRole_Administrator" Enabled="true"/>
</Manifest>
}

/// set vars("NAMESPACE")="user1"
/// set vars("SOURCESPATH")= "C:\Users\eduard\Desktop\ml.engine.xml"
/// set sc = ##class(ml.engine.Installer).Setup(.vars)
ClassMethod Setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

/// Set production as default. 
/// Load test data
/// Set libpython3.6m.so as PythonLib
ClassMethod ConfigureProduction() As %Status
{
	#dim sc As %Status = $$$OK
	set production = "ml.engine.Production"
	set ^Ens.Configuration("csp","LastProduction") = production
		
	quit sc
}

}


Imports System.Reflection
Imports System.Web.UI
Imports System.Web.UI.WebControls

Namespace Web
    Public Class FormBinding

        Public Shared Sub BindObjectToControls(ByVal obj As Object, ByVal container As Control)
            If obj Is Nothing Then Exit Sub
            Dim objType As Type = obj.GetType
            Dim propsArray() As PropertyInfo
            Dim prop As PropertyInfo
            Dim ctrl As Control

            propsArray = GetProps(objType)

            For Each prop In propsArray
                ctrl = container.FindControl(prop.Name)
                If Not ctrl Is Nothing Then
                    If TypeOf ctrl Is ListControl Then
                        Dim listCtrl As ListControl = CType(ctrl, ListControl)
                        Dim propVal As String = prop.GetValue(obj, Nothing).ToString
                        Dim item As ListItem = listCtrl.Items.FindByValue(propVal)
                        If Not item Is Nothing Then item.Selected = True
                    Else
                        Dim ctrlType As Type = ctrl.GetType
                        Dim ctrlProps() As PropertyInfo = GetProps(ctrlType)
                        Dim success As Boolean = False

                        success = FindAndSetControlProperty(obj, prop, ctrl, ctrlProps, "Checked", GetType(Boolean))

                        If Not success Then
                            success = FindAndSetControlProperty(obj, prop, ctrl, ctrlProps, "SelectedDate", GetType(DateTime))
                        End If

                        If Not success Then
                            success = FindAndSetControlProperty(obj, prop, ctrl, ctrlProps, "Value", GetType(String))
                        End If

                        If Not success Then
                            success = FindAndSetControlProperty(obj, prop, ctrl, ctrlProps, "Text", GetType(String))
                        End If

                    End If
                End If
            Next

        End Sub

        Public Shared Sub BindControlsToObject(ByVal obj As Object, ByVal container As Control)
            Dim objType As Type = obj.GetType
            Dim propsArray() As PropertyInfo
            Dim prop As PropertyInfo
            Dim ctrl As Control

            propsArray = GetProps(objType)

            For Each prop In propsArray
                ctrl = container.FindControl(prop.Name)
                If Not ctrl Is Nothing Then
                    If TypeOf ctrl Is ListControl Then
                        Dim listCtrl As ListControl = CType(ctrl, ListControl)
                        If Not listCtrl.SelectedItem Is Nothing Then
                            prop.SetValue(obj, Convert.ChangeType(listCtrl.SelectedItem.Value, prop.PropertyType), Nothing)
                        End If
                    Else
                        Dim ctrlType As Type = ctrl.GetType
                        Dim ctrlProps() As PropertyInfo = GetProps(ctrlType)
                        Dim success As Boolean = False

                        success = FindAndGetControlProperty(obj, prop, ctrl, ctrlProps, "Checked", GetType(Boolean))

                        If Not success Then
                            success = FindAndGetControlProperty(obj, prop, ctrl, ctrlProps, "SelectedDate", GetType(DateTime))
                        End If

                        If Not success Then
                            success = FindAndGetControlProperty(obj, prop, ctrl, ctrlProps, "Value", GetType(String))
                        End If

                        If Not success Then
                            success = FindAndGetControlProperty(obj, prop, ctrl, ctrlProps, "Text", GetType(String))
                        End If
                    End If

                End If
            Next

        End Sub

        Private Shared Function FindAndSetControlProperty(ByVal obj As Object, ByVal prop As PropertyInfo, ByVal ctrl As Control, ByVal ctrlProps() As PropertyInfo, ByVal propName As String, ByVal type As Type) As Boolean
            Dim ctrlProp As PropertyInfo

            For Each ctrlProp In ctrlProps
                If (ctrlProp.Name.ToLower = propName.ToLower AndAlso TypeOf ctrlProp.PropertyType Is Type) Then
                    ctrlProp.SetValue(ctrl, Convert.ChangeType(prop.GetValue(obj, Nothing), type), Nothing)
                    Return True
                End If
            Next

            Return False
        End Function

        Private Shared Function FindAndGetControlProperty(ByVal obj As Object, ByVal prop As PropertyInfo, ByVal ctrl As Control, ByVal ctrlProps() As PropertyInfo, ByVal propName As String, ByVal type As Type) As Boolean
            Dim ctrlProp As PropertyInfo

            For Each ctrlProp In ctrlProps
                If ctrlProp.Name.ToLower = propName.ToLower AndAlso TypeOf ctrlProp.PropertyType Is Type Then
                    Try
                        prop.SetValue(obj, Convert.ChangeType(ctrlProp.GetValue(ctrl, Nothing), prop.PropertyType), Nothing)
                        Return True
                    Catch ex As Exception
                        Return False
                    End Try
                End If
            Next

            Return False
        End Function


        Protected Shared Function GetCache(ByVal CacheKey As String) As Object
            Dim objCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache
            Return objCache(CacheKey)
        End Function
        Protected Shared Sub SetCache(ByVal CacheKey As String, ByVal objObject As Object)
            Dim objCache As System.Web.Caching.Cache = System.Web.HttpRuntime.Cache
            objCache.Insert(CacheKey, objObject)
        End Sub
        Protected Shared Function GetProps(ByVal type As Type) As PropertyInfo()
            Dim props() As PropertyInfo


            'props = New ArrayList
            'Dim prop As PropertyInfo
            'For Each prop In type.GetProperties
            '    props.Add(prop)
            'Next

            props = GetCache(type.FullName & "2")
            If props Is Nothing Then
                props = type.GetProperties

                SetCache(type.FullName & "2", props)
            End If

            Return props
        End Function

        Protected Shared Function ClearCache()
            Dim e As System.Collections.IDictionaryEnumerator
            e = System.Web.HttpRuntime.Cache.GetEnumerator

            While e.MoveNext
                System.Web.HttpRuntime.Cache.Remove(e.Key)
            End While

        End Function
    End Class

End Namespace
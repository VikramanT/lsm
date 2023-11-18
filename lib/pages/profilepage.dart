
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  //late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
   // _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
   // _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF78A1D2),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 396,
                height: 148,
                decoration: BoxDecoration(
                  //color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                         child: const Text('Disabled'),
                         
                        ),
                      ],
                    ),
                    Container(
                      width: 100,
                      height: 19,
                      decoration: BoxDecoration(
                    //    color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/859/600',
                        width: 64,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Hello World',
                     // style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                width: 398,
                height: 351,
                decoration: BoxDecoration(
                //  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Hello World',
                    //  style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

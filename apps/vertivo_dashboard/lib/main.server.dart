import 'package:jaspr/server.dart';
import 'app.dart';

void main() {
  Jaspr.initializeApp();

  runApp(Document(
    title: 'Vertivo Dashboard',
    lang: 'es',
    head: [
      // Typography — Inter (brand) + Material Symbols (M3 icons)
      link(href: 'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap', rel: 'stylesheet'),
      link(href: 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200', rel: 'stylesheet'),
      // D3.js for charts
      script(src: 'https://d3js.org/d3.v7.min.js', []),
      // Stylesheets
      link(href: '/styles.css', rel: 'stylesheet'),
      // Material Web Components (M3 Expressive)
      script(src: '/material-init.js', attributes: {'type': 'module'}, []),
      // D3 dashboard visualizations
      script(src: '/dashboard.js', attributes: {'defer': ''}, []),
    ],
    body: App(),
  ));
}

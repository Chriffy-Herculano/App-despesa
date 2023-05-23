import 'package:flutter/material.dart';
import 'package:projeto_ex1/listadespesa.dart';
import 'package:projeto_ex1/models/despesa.dart';
import 'package:projeto_ex1/models/despesas_dao.dart';

class RegDespesa extends StatefulWidget {
  const RegDespesa({super.key});

  @override
  State<RegDespesa> createState() => _RegDespesa();
}

class _RegDespesa extends State<RegDespesa> {
  List<Despesa> despesa = [];

  final DespesaDao dao = DespesaDao();

  TextEditingController nomeDespesa = TextEditingController();
  TextEditingController tipoDespesa = TextEditingController();
  TextEditingController valorDespesa = TextEditingController();
  double _valorDespesaDouble = 0;

  _RegDespesa() {
    dao.connect().then((value) {
      load();
    });
  }

  load() {
    dao.list().then((value) {
      setState(() {
        despesa = value;
        nomeDespesa.text = "";
        tipoDespesa.text = "";
        valorDespesa.text = "";
      });
    });
  }

  @override
  void dispose() {
    valorDespesa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registro de despesas',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.all(5),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Entre com o nome da despesa?',
                ),
                controller: nomeDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira uma despesa';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tipo da despesa',
                ),
                controller: tipoDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira o tipo da despesa';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Valor da despesa',
                ),
                controller: valorDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira o valor da despesa';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (nomeDespesa.text.trim() != '') {
                          var dep = Despesa(
                            nomeDespesa: nomeDespesa.text,
                            tipoDespesa: tipoDespesa.text,
                            valorDespesa: _valorDespesaDouble =
                                double.parse(valorDespesa.text),
                          );
                          dao.insert(dep).then((value) {
                            load();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        //primary: Color.fromARGB(255, 88, 109, 180),
                        backgroundColor:
                            const Color.fromARGB(255, 88, 109, 180),
                        // Define a cor do botão
                      ),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ListaDespesa())));
                      },
                      style: ElevatedButton.styleFrom(
                        //primary: Color.fromARGB(255, 88, 109, 180),
                        backgroundColor:
                            const Color.fromARGB(255, 88, 109, 180),
                        // Define a cor do botão
                      ),
                      child: const Text(
                        'Consultar Despesas',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              listView(),
              Text('Total: RS ${soma()}')
            ],
          ),
        ),
      ),
    );
  }

  listView() {
    return Expanded(
      child: ListView.builder(
        //shrinkWrap: true,
        itemCount: despesa.length,
        itemBuilder: (context, index) {
          //cria um lista com título e subtítulo
          return ListTile(
            title: Text(
              despesa[index].nomeDespesa,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
                'Tipo: ${despesa[index].tipoDespesa}\nRS ${despesa[index].valorDespesa}'),
            //ao clicar sobre um contato da lista, exibe seu
            //nome e telefone
            onTap: () {
              setState(() {
                nomeDespesa.text = despesa[index].nomeDespesa;
                tipoDespesa.text = despesa[index].tipoDespesa;
                valorDespesa.text = despesa[index].valorDespesa.toString();
              });
            },
          );
        },
      ),
    );
  }

  double soma() {
    double total = 0;
    for (var valor in despesa) {
      total += valor.valorDespesa;
    }

    return total;
  }
}

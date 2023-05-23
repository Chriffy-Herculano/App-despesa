import 'package:flutter/material.dart';

import 'models/despesa.dart';
import 'models/despesas_dao.dart';

class ListaDespesa extends StatefulWidget {
  const ListaDespesa({super.key});

  @override
  State<ListaDespesa> createState() => _ListaDespesa();
}

class _ListaDespesa extends State<ListaDespesa> {
  final DespesaDao dao = DespesaDao();

  List<Despesa> despesa = [];

  bool _isValor = false;

  TextEditingController nomeDespesa = TextEditingController();
  TextEditingController tipoDespesa = TextEditingController();
  TextEditingController valorDespesa = TextEditingController();

  _ListaDespesa() {
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
        valorDespesa.text = "0";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Consultar despesa'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
        padding: const EdgeInsets.all(5),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pesquisa por despesa',
                  hintText: 'Entre com o tipo da despesa',
                ),
                controller: tipoDespesa,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Insira uma despesa';
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
                        setState(() {
                          _isValor = !_isValor;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        //primary: Color.fromARGB(255, 88, 109, 180),
                        backgroundColor:
                            const Color.fromARGB(255, 88, 109, 180),
                        // Define a cor do botão
                      ),
                      child: const Text(
                        'Pesquisar despesa',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _isValor ? listView() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  listView() {
    return Expanded(
      child: ListTile(
        title: Text(
          tipoDespesa.text,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        subtitle: Text('Total: RS${totalDespesa()}'),
        //ao clicar sobre um contato da lista, exibe seu
        //nome e telefone
        onTap: () {
          setState(() {});
        },
      ),
    );
  }

  double totalDespesa() {
    double total = 0;
    for (var valor in despesa) {
      if (valor.tipoDespesa == tipoDespesa.text) {
        total += valor.valorDespesa;
      }
    }
    return total;
  }
}

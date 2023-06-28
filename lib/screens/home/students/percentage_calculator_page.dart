import 'package:flutter/material.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({Key? key}) : super(key: key);

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  final TextEditingController _controller = TextEditingController();
  double _percentage = 0.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePercentage() {
    double inputValue = double.tryParse(_controller.text) ?? 0.0;
    double percentage =
        (inputValue >= 4 && inputValue <= 10) ? (inputValue - 0.5) * 10 : 0;
    setState(() {
      _percentage = percentage.clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Percentage Calculator"),
      ),
      body: Column(
        children: [
          InputBox(
            size: size,
            controller: _controller,
            onChanged: _updatePercentage,
          ),
          const WarnText(),
          const SizedBox(
            height: 25.0,
          ),
          // CircularPercentIndicator(
          //   radius: 65.0,
          //   lineWidth: 15.0,
          //   percent: _percentage / 100,
          //   backgroundColor: kPrimaryColor.withOpacity(0.2),
          //   center: Text(
          //     "${_percentage.toStringAsFixed(0)}%",
          //     style: TextStyle(color: kPrimaryColor, fontSize: 25.0),
          //   ),
          //   progressColor: kPrimaryColor,
          // )
        ],
      ),
    );
  }
}

class WarnText extends StatelessWidget {
  const WarnText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "SPI/CPI/CGPA must be between 4 to 10",
      style: TextStyle(color: Colors.red, fontSize: 15, letterSpacing: 1),
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({
    Key? key,
    required this.size,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final Size size;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: size.width,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            counterText: "",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            labelText: "SPI/CPI/CGPA",
            labelStyle: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

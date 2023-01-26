# Generate Coverage Report
run-tests: 
	flutter pub get
	mkdir -p coverage/unit && flutter test test --coverage coverage/unit
	cp coverage/lcov.info ./coverage/unit
	mkdir -p coverage/integration && flutter test integration_test --coverage coverage/integration
	cp coverage/lcov.info ./coverage/integration

# Generate Coverate Report and view report
gen-coverage-report:
	make run-tests 
	lcov --add-tracefile coverage/integration/lcov.info --add-tracefile coverage/unit/lcov.info  --output-file coverage/lcov.info
	lcov --remove coverage/lcov.info 'lib/l10n/*' 'lib/res/*' -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/
	open coverage/index.html

gen-l10n:
	flutter gen-l10n

build-di:
	flutter pub get
	flutter pub run build_runner build

analyze-metrics:
	flutter pub run dart_code_metrics:metrics lib
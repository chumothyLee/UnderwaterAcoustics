

fp = open('output.csv')

total = [0]*9
correct = [0]*9

for line in fp:
  [col1, col2] = line.split(',')
  col1 = int(col1)
  col2 = int(col2)

  total[col1-1] = total[col1-1] + 1

  if col1 == col2:
    correct[col1-1] = correct[col1-1] + 1

blank_error = 1.0 - float(correct[0])/(total[0])
noise_error = 1.0 - float(correct[1])/(total[1])
croak_error = 1.0 - float(correct[2])/(total[2])
jetski_error = 1.0 - float(correct[3])/(total[3])
click_error = 1.0 - float(correct[4])/(total[4])
pulse_error = 1.0 - float(correct[5])/(total[5])
buzz_error = 1.0 - float(correct[6])/(total[6])
downsweep_error = 1.0 - float(correct[7])/(total[7])
beat_error = 1.0 - float(correct[8])/(total[8])

print "Blank error rate: %.5f\n" % blank_error
print "Noise error rate: %.5f\n" % noise_error
print "Croak error rate: %.5f\n" % croak_error
print "Jetski error rate: %.5f\n" % jetski_error
print "Click Train error rate: %.5f\n" % click_error
print "Pulse Train error rate: %.5f\n" % pulse_error
print "Buzz error rate: %.5f\n" % buzz_error
print "Downsweep error rate: %.5f\n" % downsweep_error
print "Beat error rate: %.5f\n" % beat_error
'''

Build yields for HIG-12-053 results table using data card.


'''

from DataCard import DataCard
import os
import string
import sigfigs

# Get the combination of all channels
megacard = DataCard('megacard_125.txt')

# Store yields for various processes
yields = {
    'llt': {},
    'ltt': {},
    'zh': {},
}

# Get LLT yields
yields['llt']['wz'] = megacard.get_rate('llt*', 'wz')
yields['llt']['zz'] = megacard.get_rate('llt*', 'zz')
yields['llt']['fakes'] = megacard.get_rate('llt*', 'fakes')
yields['llt']['VH'] = megacard.get_rate('llt*', 'WH')
yields['llt']['VHww'] = megacard.get_rate('llt*', 'WH_hww')
yields['llt']['total'] = (
    yields['llt']['wz'] + yields['llt']['zz'] + yields['llt']['fakes'])
yields['llt']['obs'] = megacard.get_obs('llt*')

yields['ltt']['wz'] = megacard.get_rate('ltt*', 'wz')
yields['ltt']['zz'] = megacard.get_rate('ltt*', 'zz')
yields['ltt']['fakes'] = megacard.get_rate('ltt*', 'fakes')
yields['ltt']['VH'] = megacard.get_rate('ltt*', 'VH')
yields['ltt']['VHww'] = 0
yields['ltt']['total'] = (
    yields['ltt']['wz'] + yields['ltt']['zz'] + yields['ltt']['fakes'])
yields['ltt']['obs'] = megacard.get_obs('ltt*')
is_blind = os.environ.get('blind', 'NO') == 'YES'
yields['ltt']['obs'] = 'blind' if is_blind else megacard.get_obs('ltt*')

yields['zh']['zz'] = megacard.get_rate('ZH*', 'ZZ')
yields['zh']['fakes'] = megacard.get_rate('ZH*', 'Zjets')
yields['zh']['VH'] = megacard.get_rate('ZH*', 'ZH_htt')
yields['zh']['VHww'] = megacard.get_rate('ZH*', 'ZH_hww')
yields['zh']['total'] = yields['zh']['zz'] + yields['zh']['fakes']
yields['zh']['obs'] = megacard.get_obs('ZH*')


def render(the_yield):
    if isinstance(the_yield, int):
        return str(the_yield)
    elif isinstance(the_yield, float):
        return "%0.f" % the_yield
    elif isinstance(the_yield, basestring):
        return the_yield
    return r'$ %s \pm %s $' % sigfigs.sigfigs(
        the_yield.nominal_value, the_yield.std_dev(), 2, -1)

# flatten dictionary and stringify yields
flat = {}
for channel, channel_info in yields.iteritems():
    for process, process_yield in channel_info.iteritems():
        flat[channel + process] = render(process_yield)

vh_template = r'''
    \begin{tabular}{l | c | c | c}
      Process &$$\ell \ell \tau_h$$& $$\ell\tau_h\tau_h$$ & $$\ell\ell LL$$ \\
      \hline
      Fakes & $lltfakes & $lttfakes & \multirow{2}{*}{$zhfakes} \\
      WZ & $lltwz & $lttwz & \\
      \hline
      ZZ & $lltzz & $lttzz & $zhzz \\
      \hline
      \hline
      Total bkg. &  $llttotal & $ltttotal & $zhtotal \\
      \hline
      VH$$\to$$V$$\tau\tau (m_H=125\GeV)$$ & $lltVH & $lttVH & $zhVH \\
      VH$$\to$$VWW $$(m_H=125\GeV)$$ & $lltVHww & $lttVHww & $zhVHww \\
      \hline
      Observed & $lltobs & $lttobs & $zhobs  \\
    \end{tabular}
'''

with open('vh_table.tex', 'w') as vh_file:
    vh_file.write(string.Template(vh_template).substitute(**flat))

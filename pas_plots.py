'''

Make plots for the HIG-12-053 PAS

'''

from RecoLuminosity.LumiDB import argparse
import math
import os
from poisson import convert
import ROOT
ROOT.gROOT.SetBatch(True)
ROOT.gROOT.ProcessLine('.x tdrStyle.C')

postfit_src = os.path.join(os.environ['CMSSW_BASE'],
                           'src/HiggsAnalysis/HiggsToTauTau/test/',
                           'root_postfit')


def fix_maximum(channel_dict, cushion=1.1):
    """ Make sure everything is visible """
    max = channel_dict['stack'].GetMaximum()
    histo = channel_dict['data']
    for bin in range(histo.GetNbinsX()):
        content = histo.GetBinContent(bin)
        upper = content + math.sqrt(content)
        #print bin, upper, max
        if upper > max:
            max = upper
    channel_dict['stack'].SetMaximum(cushion * max)


def add_cms_blurb(sqrts, intlumi, preliminary=True, blurb=''):
    """ Add a CMS blurb to a plot """
    latex = ROOT.TLatex()
    latex.SetNDC()
    latex.SetTextSize(0.04)
    latex.SetTextAlign(31)
    latex.SetTextAlign(11)
    label_text = "CMS"
    if preliminary:
        label_text += " Preliminary"
    label_text += " %s TeV" % sqrts
    label_text += " L = %sfb^{-1}" % (intlumi)
    label_text += " " + blurb
    return latex.DrawLatex(0.18, 0.97, label_text)

_styles = {
    "main_irreducible": {
        # Same as Z+jets
        'fillstyle': 1001,
        #'fillcolor': '#FFCC66',
        'fillcolor': ROOT.EColor.kOrange - 4,
        'linecolor': ROOT.EColor.kBlack,
        'linewidth': 3,
    },
    "next_irreducible": {
        # Same as W+jets
        'fillstyle': 1001,
        #'fillcolor': '#990000',
        'fillcolor': ROOT.EColor.kRed + 2,
        'linecolor': ROOT.EColor.kBlack,
        'linewidth': 3,
    },
    "fakes": {
        # Same as QCD
        #'fillcolor': '#FFCCFF',
        'fillcolor': ROOT.EColor.kMagenta - 10,
        'linecolor': ROOT.EColor.kBlack,
        'fillstyle': 1001,
        'linewidth': 3,
    },
    "signal": {
        'fillcolor': 0,
        'fillstyle': 0,
        'linestyle': 2,
        'linewidth': 5,
        #'linecolor': '#1C1C76',
        'fillcolor': ROOT.EColor.kRed,
        'name': "VH",
    },
    "data": {
        'markerstyle': 20,
        'markersize': 2,
        'linewidth': 2,
        'markercolor': ROOT.EColor.kBlack,
        'legendstyle': 'pe',
        'format': 'pe',
        'name': "Observed",
    }
}


def apply_style(histogram, style_type):
    style = _styles[style_type]
    if 'fillstyle' in style:
        histogram.SetFillStyle(style['fillstyle'])
    if 'fillcolor' in style:
        histogram.SetFillColor(style['fillcolor'])
    if 'linecolor' in style:
        histogram.SetLineColor(style['linecolor'])
    if 'linestyle' in style:
        histogram.SetLineStyle(style['linestyle'])
    if 'linewidth' in style:
        histogram.SetLineWidth(style['linewidth'])
    if 'markersize' in style:
        histogram.SetMarkerSize(style['markersize'])
    if 'markercolor' in style:
        histogram.SetMarkerColor(style['markercolor'])


def get_combined_histogram(histograms, directories, files, title=None,
                           scale=None, style=None):
    """ Get a histogram that is the combination of all paths/files"""
    if isinstance(histograms, basestring):
        histograms = [histograms]
    output = None
    for file in files:
        for path in directories:
            for histogram in histograms:
                th1 = file.Get(path + '/' + histogram)
                if output is None:
                    output = th1.Clone()
                else:
                    output.Add(th1)
    if scale is not None:
        output.Scale(scale)
    if title is not None:
        output.SetTitle(title)
    if style:
        apply_style(output, style)
    return output


if __name__ == "__main__":
    # The input files
    parser = argparse.ArgumentParser()

    parser.add_argument('--prefit', action='store_true',
                        help="Don't use postfit")

    parser.add_argument('--period', default="all",
                        choices=['7TeV', '8TeV', 'all'],
                        help="Which data taking period")

    args = parser.parse_args()

    prefit_7TeV_file = ROOT.TFile.Open(
        "limits/cmb/common/vhtt.input_7TeV.root")
    prefit_8TeV_file = ROOT.TFile.Open(
        "limits/cmb/common/vhtt.input_8TeV.root")

    postfit_7TeV_file = ROOT.TFile.Open(postfit_src + "/vhtt.input_7TeV.root")
    postfit_8TeV_file = ROOT.TFile.Open(postfit_src + "/vhtt.input_8TeV.root")

    files_to_use_map = {
        (True, '7TeV'): [prefit_7TeV_file],
        (True, '8TeV'): [prefit_8TeV_file],
        (True, 'all'): [prefit_8TeV_file, prefit_7TeV_file],
        (False, '7TeV'): [postfit_7TeV_file],
        (False, '8TeV'): [postfit_8TeV_file],
        (False, 'all'): [postfit_8TeV_file, postfit_7TeV_file],
    }

    files_to_use = files_to_use_map[(args.prefit, args.period)]

    # Get all our histograms
    histograms = {}

    # LLT
    histograms['llt'] = {}
    llt_channels = ['emt', 'mmt']

    histograms['llt']['wz'] = get_combined_histogram(
        'wz', llt_channels, files_to_use, title='WZ',
        style='main_irreducible'
    )

    histograms['llt']['zz'] = get_combined_histogram(
        'zz', llt_channels, files_to_use, title='ZZ',
        style='next_irreducible'
    )

    histograms['llt']['fakes'] = get_combined_histogram(
        'fakes', llt_channels, files_to_use, title='Non-prompt', style='fakes'
    )

    histograms['llt']['signal'] = get_combined_histogram(
        ['WH125', 'WH_hww125'], llt_channels, files_to_use,
        title='m_{H}=125 GeV', style='signal',
    )

    histograms['llt']['data'] = get_combined_histogram(
        'data_obs', llt_channels, files_to_use,
        title='data', style='data'
    )

    def make_legend():
        output = ROOT.TLegend(0.45, 0.6, 0.89, 0.93, "", "brNDC")
        output.SetLineWidth(0)
        output.SetLineStyle(0)
        output.SetFillStyle(0)
        output.SetBorderSize(0)
        return output

    histograms['llt']['stack'] = ROOT.THStack("llt_stack", "llt_stack")
    histograms['llt']['stack'].Add(histograms['llt']['zz'], 'hist')
    histograms['llt']['stack'].Add(histograms['llt']['fakes'], 'hist')
    histograms['llt']['stack'].Add(histograms['llt']['wz'], 'hist')
    histograms['llt']['stack'].Add(histograms['llt']['signal'], 'hist')

    histograms['llt']['legend'] = make_legend()
    histograms['llt']['legend'].AddEntry(histograms['llt']['zz'], "ZZ", "f")
    histograms['llt']['legend'].AddEntry(histograms['llt']['fakes'],
                                         "Non-prompt", "f")
    histograms['llt']['legend'].AddEntry(histograms['llt']['wz'], "WZ", "f")
    histograms['llt']['legend'].AddEntry(histograms['llt']['signal'],
                                         "m_{H} = 125 GeV", "l")
    histograms['llt']['legend'].AddEntry(histograms['llt']['data'],
                                         "Observed", "lpe")

    # ZH
    histograms['zh'] = {}
    zh_channels = [
        'eeem_zh', 'eeet_zh', 'eemt_zh', 'eett_zh',
        'mmme_zh', 'mmet_zh', 'mmmt_zh', 'mmtt_zh',
    ]

    histograms['zh']['zz'] = get_combined_histogram(
        'ZZ', zh_channels, files_to_use, title='ZZ',
        style='main_irreducible'
    )

    histograms['zh']['fakes'] = get_combined_histogram(
        'Zjets', zh_channels, files_to_use, title='Non-prompt',
        style='fakes'
    )

    histograms['zh']['signal'] = get_combined_histogram(
        ['ZH_htt125', 'ZH_hww125'], zh_channels, files_to_use,
        title='m_{H}=125 GeV', style='signal',
    )

    histograms['zh']['data'] = get_combined_histogram(
        'data_obs', zh_channels, files_to_use,
        title='data', style='data')

    histograms['zh']['stack'] = ROOT.THStack("zh_stack", "zh_stack")
    histograms['zh']['stack'].Add(histograms['zh']['zz'], 'hist')
    histograms['zh']['stack'].Add(histograms['zh']['fakes'], 'hist')
    histograms['zh']['stack'].Add(histograms['zh']['signal'], 'hist')

    histograms['zh']['legend'] = make_legend()
    histograms['zh']['legend'].AddEntry(histograms['zh']['zz'], "ZZ", "f")
    histograms['zh']['legend'].AddEntry(histograms['zh']['fakes'],
                                        "Non-prompt", "f")
    histograms['zh']['legend'].AddEntry(histograms['zh']['signal'],
                                        "m_{H} = 125 GeV", "l")
    histograms['zh']['legend'].AddEntry(histograms['zh']['data'],
                                        "Observed", "lpe")

    # LTT
    histograms['ltt'] = {}
    ltt_channels = ['ett', 'mtt']

    histograms['ltt']['wz'] = get_combined_histogram(
        'wz', ltt_channels, files_to_use, title='WZ',
        style='main_irreducible',
    )

    histograms['ltt']['zz'] = get_combined_histogram(
        'zz', ltt_channels, files_to_use, title='ZZ',
        style='next_irreducible',)

    histograms['ltt']['fakes'] = get_combined_histogram(
        'fakes', ltt_channels, files_to_use, title='Non-prompt',
        style='fakes',
    )

    histograms['ltt']['signal'] = get_combined_histogram(
        ['VH125'], ltt_channels, files_to_use,
        title='m_{H}=125 GeV', style='signal')

    histograms['ltt']['data'] = get_combined_histogram(
        'data_obs', ltt_channels, files_to_use,
        title='data', style='data')

    histograms['ltt']['stack'] = ROOT.THStack("ltt_stack", "ltt_stack")
    histograms['ltt']['stack'].Add(histograms['ltt']['zz'], "hist")
    histograms['ltt']['stack'].Add(histograms['ltt']['fakes'], "hist")
    histograms['ltt']['stack'].Add(histograms['ltt']['wz'], "hist")
    histograms['ltt']['stack'].Add(histograms['ltt']['signal'], "hist")

    histograms['ltt']['legend'] = make_legend()
    histograms['ltt']['legend'].AddEntry(histograms['ltt']['zz'], "ZZ", "f")
    histograms['ltt']['legend'].AddEntry(histograms['ltt']['fakes'],
                                         "Non-prompt", "f")
    histograms['ltt']['legend'].AddEntry(histograms['ltt']['wz'], "WZ", "f")
    histograms['ltt']['legend'].AddEntry(histograms['ltt']['signal'],
                                         "m_{H} = 125 GeV", "l")
    histograms['ltt']['legend'].AddEntry(histograms['ltt']['data'],
                                         "Observed", "lpe")

    # Apply some styles to all the histograms
    for channel in ['llt', 'zh', 'ltt']:
        # Use Poissonian error bars. The set_zero_bins makes it so bins w/o
        # any data are blank.
        histograms[channel]['poisson'] = convert(histograms[channel]['data'],
                                                 set_zero_bins=-10)
        # Make sure all data points are visible
        fix_maximum(histograms[channel])
        # We have to draw it so things like the axes are initialized.
        histograms[channel]['stack'].Draw()
        histograms[channel]['stack'].GetYaxis().SetTitle(
            "Events/%i GeV" % histograms[channel]['data'].GetBinWidth(1))
        histograms[channel]['stack'].GetXaxis().SetTitle("m_{vis} [GeV]")
        if channel == 'llt': #srink the label size
            labelSize = histograms[channel]['stack'].GetXaxis().GetLabelSize()
            histograms[channel]['stack'].GetXaxis().SetLabelSize(labelSize*0.8)


    plot_suffix = "_%s_%s.pdf" % (
        'prefit' if args.prefit else 'postfit',
        args.period
    )

    # Figure out what goes in the CMS preliminary line
    blurb_map = {
        '7TeV': ('5', '7'),
        '8TeV': ('19', '8'),
        'all': ('24', '7+8'),
    }
    int_lumi, sqrts = blurb_map[args.period]

    canvas = ROOT.TCanvas("asdf", "asdf", 800, 800)
    canvas.SetTopMargin(0.05)
    canvas.SetRightMargin(0.1)

    histograms['llt']['stack'].Draw()
    histograms['llt']['poisson'].Draw('pe same')
    histograms['llt']['legend'].Draw()
    add_cms_blurb(sqrts, int_lumi)
    canvas.SaveAs('plots/llt' + plot_suffix)

    histograms['zh']['stack'].Draw()
    histograms['zh']['stack'].GetHistogram().GetXaxis().SetRangeUser(0, 200)
    histograms['zh']['poisson'].Draw('pe same')
    histograms['zh']['legend'].Draw()
    add_cms_blurb(sqrts, int_lumi)
    canvas.SaveAs('plots/zh' + plot_suffix)

    histograms['ltt']['stack'].Draw()
    histograms['ltt']['poisson'].Draw('pe same')
    histograms['ltt']['legend'].Draw()
    add_cms_blurb(sqrts, int_lumi)
    canvas.SaveAs('plots/ltt' + plot_suffix)

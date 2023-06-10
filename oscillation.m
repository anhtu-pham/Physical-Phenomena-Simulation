classdef oscillation < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TabGroup                     matlab.ui.container.TabGroup
        thinghiemTab                 matlab.ui.container.Tab
        UIAxes                       matlab.ui.control.UIAxes
        UIAxes2                      matlab.ui.control.UIAxes
        inputPanel                   matlab.ui.container.Panel
        vomsSpinnerLabel             matlab.ui.control.Label
        vomsSpinner                  matlab.ui.control.Spinner
        kNsmSpinnerLabel             matlab.ui.control.Label
        kNsmSpinner                  matlab.ui.control.Spinner
        anphaSpinnerLabel            matlab.ui.control.Label
        anphaSpinner                 matlab.ui.control.Spinner
        lengmSpinnerLabel            matlab.ui.control.Label
        lengmSpinner                 matlab.ui.control.Spinner
        masskgSpinnerLabel           matlab.ui.control.Label
        masskgSpinner                matlab.ui.control.Spinner
        grapButton                   matlab.ui.control.Button
        animationButton              matlab.ui.control.Button
        outputPanel                  matlab.ui.container.Panel
        timeEditFieldLabel           matlab.ui.control.Label
        timeEditField                matlab.ui.control.NumericEditField
        Button                       matlab.ui.control.Button
        xEditFieldLabel              matlab.ui.control.Label
        xEditField                   matlab.ui.control.NumericEditField
        aEditFieldLabel              matlab.ui.control.Label
        aEditField                   matlab.ui.control.NumericEditField
        vEditFieldLabel              matlab.ui.control.Label
        vEditField                   matlab.ui.control.NumericEditField
        selectPanel                  matlab.ui.container.Panel
        resetButton                  matlab.ui.control.Button
        selectDropDownLabel          matlab.ui.control.Label
        selectDropDown               matlab.ui.control.DropDown
        gridSwitchLabel              matlab.ui.control.Label
        gridSwitch                   matlab.ui.control.Switch
        huongdanTab                  matlab.ui.container.Tab
        HngdnsdngLabel               matlab.ui.control.Label
        UIAxes3                      matlab.ui.control.UIAxes
        thbiudinmiquanhgiathigianvvntcgiathigianvlidaongLabel_2  matlab.ui.control.Label
        UIAxes4                      matlab.ui.control.UIAxes
        thmtsgiaongcaconlcLabel      matlab.ui.control.Label
        vomsvntcbanucaconlcLabel     matlab.ui.control.Label
        kNSMhsLabel                  matlab.ui.control.Label
        anphagcnghingcaconlcsovitrcthngngLabel  matlab.ui.control.Label
        lengmchiudicadyLabel         matlab.ui.control.Label
        masskgkhilngcaconlcLabel_2   matlab.ui.control.Label
        g98ms2Label_2                matlab.ui.control.Label
        resetButton_2                matlab.ui.control.Button
        graphButton                  matlab.ui.control.Button
        Button_2                     matlab.ui.control.Button
        animationButton_2            matlab.ui.control.Button
        chylichngtrnhLabel           matlab.ui.control.Label
        ntvthLabel                   matlab.ui.control.Label
        ntchychngtrnhraccthngsLabel  matlab.ui.control.Label
        ntvconlcmtgiaongLabel        matlab.ui.control.Label
        SwitchLabel                  matlab.ui.control.Label
        Switch                       matlab.ui.control.Switch
        bttttacathLabel              matlab.ui.control.Label
        selectDropDown_2Label        matlab.ui.control.Label
        selectDropDown_2             matlab.ui.control.DropDown
        chnmiquanhchoththigianvvntchocthigianvligiaongLabel  matlab.ui.control.Label
        timethigianconlcgiaongLabel  matlab.ui.control.Label
        liEditFieldLabel             matlab.ui.control.Label
        liEditField                  matlab.ui.control.EditField
        vntcEditFieldLabel           matlab.ui.control.Label
        vntcEditField                matlab.ui.control.EditField
        giatcEditFieldLabel          matlab.ui.control.Label
        giatcEditField               matlab.ui.control.EditField
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: grapButton
        function grapButtonPushed(app, event)
            cla(app.UIAxes,'reset');
            value = app.gridSwitch.Value;
            if value == "On"
                grid(app.UIAxes,"on");
            else
                grid(app.UIAxes,"off");
            end
            k = app.kNsmSpinner.Value; 
            m = app.masskgSpinner.Value;
            vo = app.vomsSpinner.Value;
            l = app.lengmSpinner.Value;
            xo = app.anphaSpinner.Value/180*pi*l;
            g = 10;
            % Choose
            select = app.selectDropDown.Value;
            %--------------------------
            % Solve differential equation
            syms x(t);
            D1x = diff(x,t);
            D2x = diff(x,t,2);
            eqn = D2x == -k/m*D1x -g/l*x;
            cond = [x(0) == xo ,D1x(0) == vo];
            ans1 = dsolve (eqn,cond);
            ans2 = diff(ans1,t);
            hold(app.UIAxes,'on');
            
            omega = (g/l)^1/2;
            T = 2*pi/omega;
            time = 0:T/100:5*T
            x_data = [];
            v_data = [];
            
            if select == 'x(t)'
                for i = 0:T/100:5*T
                    xnew = subs(ans1,t,i);
                    x_data = [x_data xnew];
                end
                plot(app.UIAxes,time,x_data);
            elseif select =='v(t)'
                for i = 0:T/100:5*T
                    vnew = subs(ans2,t,i);
                    v_data = [v_data vnew];
                end
                plot(app.UIAxes,time,v_data)
            end
        end

        % Value changed function: gridSwitch
        function gridSwitchValueChanged(app, event)
            value = app.gridSwitch.Value;
            if value == "On"
                grid(app.UIAxes,"on");
            else
                grid(app.UIAxes,"off");
            end
        end

        % Button pushed function: resetButton
        function resetButtonPushed(app, event)
            cla(app.UIAxes,'reset');
        end

        % Value changed function: selectDropDown
        function selectDropDownValueChanged(app, event)
            value = app.selectDropDown.Value;
            if value == 'x(t)'
                app.UIAxes.YLabel.String = "x(m)"
                app.UIAxes.Title.String = "x(t)"
            elseif value =='v(t)'
                 app.UIAxes.YLabel.String = "v(m/s)"
                app.UIAxes.Title.String = "v(t)"
            end
        end

        % Button pushed function: animationButton
        function animationButtonPushed(app, event)
            cla(app.UIAxes,'reset');
            k = app.kNsmSpinner.Value; 
            m = app.masskgSpinner.Value;
            vo = app.vomsSpinner.Value;
            l = app.lengmSpinner.Value;
            xo = app.anphaSpinner.Value/180*pi*l;
            g = 10;
            % Choose
            select = app.selectDropDown.Value;
            %--------------------------
            % Solve differential equation
            syms x(t);
            D1x = diff(x,t);
            D2x = diff(x,t,2);
            eqn = D2x == -k/m*D1x -g/l*x;
            cond = [x(0) == xo ,D1x(0) == vo];
            ans1 = dsolve (eqn,cond);
            ans2 = diff(ans1,t);
            hold(app.UIAxes,'on');
            
            omega = (g/l)^1/2;
            T = 2*pi/omega;
            time = 0:T/100:5*T
            x_data = [];
            v_data = [];
            if select == 'x(t)'
                for i = 0:T/100:5*T
                    x_data = [x_data subs(ans1,t,i)];
                end
                for i = 0: T/100:T
                    cla(app.UIAxes,'reset');
                    hold(app.UIAxes,"on");
                    plot(app.UIAxes,time,x_data);
                    plot(app.UIAxes,i,subs(ans1,t,i),'o');
                    % actual oscillating pendulum
                    cla(app.UIAxes2,'reset');
                    hold(app.UIAxes2,'on');
                    curx = subs(ans1,t,i);
                    cury = -(l^2-curx^2)^1/2
                    plot(app.UIAxes2,[-l/2 l/2],[-l*1.4 -l*1.4]);
                    plot(app.UIAxes2,[0 curx],[0 cury]);
                    plot(app.UIAxes2,[0 0],[0 -l*1.4]);
                    plot(app.UIAxes2,curx,cury,'o');
                    pause(0.1);
                end
            elseif select =='v(t)'
                for i = 0:T/100:5*T
                    v_data = [v_data subs(ans2,t,i)];
                end
                for i = 0: T/100:T
                    cla(app.UIAxes,'reset');
                    hold(app.UIAxes,"on");
                    plot(app.UIAxes,time,v_data);
                    plot(app.UIAxes,i,subs(ans2,t,i),'o');
                    % actual oscillating pendulum
                    cla(app.UIAxes2,'reset');
                    hold(app.UIAxes2,'on');
                    curx = subs(ans1,t,i);
                    cury = -(l^2-curx^2)^1/2
                    plot(app.UIAxes2,[-l/2 l/2],[-l*1.4 -l*1.4]);
                    plot(app.UIAxes2,[0 curx],[0 cury]);
                    plot(app.UIAxes2,[0 0],[0 -l*1.4]);
                    plot(app.UIAxes2,curx,cury,'o');
                    pause(0.01);
                end
            end
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            k = app.kNsmSpinner.Value; 
            m = app.masskgSpinner.Value;
            vo = app.vomsSpinner.Value;
            l = app.lengmSpinner.Value;
            xo = app.anphaSpinner.Value/180*pi*l;
            g = 10;
            time = app.timeEditField.Value;
            %--------------------------
            % Solve differential equation
            syms x(t);
            D1x = diff(x,t);
            D2x = diff(x,t,2);
            eqn = D2x == -k/m*D1x -g/l*x;
            cond = [x(0) == xo ,D1x(0) == vo];
            ans1 = dsolve (eqn,cond);
            ans2 = diff(ans1,t);
            ans3 = diff(ans1,t,2);
            app.xEditField.Value = double(subs(ans1,t,time));
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [50 50 1000 750];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 1000 750];

            % Create thinghiemTab
            app.thinghiemTab = uitab(app.TabGroup);
            app.thinghiemTab.Title = 'Experiment';

            % Create UIAxes
            app.UIAxes = uiaxes(app.thinghiemTab);
            title(app.UIAxes, 'x-t')
            xlabel(app.UIAxes, 's')
            ylabel(app.UIAxes, 'x(cm)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [95 373 541 324];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.thinghiemTab);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, '')
            ylabel(app.UIAxes2, '')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [95 9 541 330];

            % Create inputPanel
            app.inputPanel = uipanel(app.thinghiemTab);
            app.inputPanel.Title = 'input';
            app.inputPanel.Position = [677 243 260 263];

            % Create vomsSpinnerLabel
            app.vomsSpinnerLabel = uilabel(app.inputPanel);
            app.vomsSpinnerLabel.HorizontalAlignment = 'right';
            app.vomsSpinnerLabel.Position = [61 209 45 22];
            app.vomsSpinnerLabel.Text = 'vo(m/s)';

            % Create vomsSpinner
            app.vomsSpinner = uispinner(app.inputPanel);
            app.vomsSpinner.Step = 0.1;
            app.vomsSpinner.Limits = [0 1];
            app.vomsSpinner.Position = [121 209 100 22];
            app.vomsSpinner.Value = 0.3;

            % Create kNsmSpinnerLabel
            app.kNsmSpinnerLabel = uilabel(app.inputPanel);
            app.kNsmSpinnerLabel.HorizontalAlignment = 'right';
            app.kNsmSpinnerLabel.Position = [54 173 51 22];
            app.kNsmSpinnerLabel.Text = 'k(N.s/m)';

            % Create kNsmSpinner
            app.kNsmSpinner = uispinner(app.inputPanel);
            app.kNsmSpinner.Step = 0.1;
            app.kNsmSpinner.Limits = [0 5];
            app.kNsmSpinner.Position = [120 173 100 22];
            app.kNsmSpinner.Value = 0.5;

            % Create anphaSpinnerLabel
            app.anphaSpinnerLabel = uilabel(app.inputPanel);
            app.anphaSpinnerLabel.HorizontalAlignment = 'right';
            app.anphaSpinnerLabel.Position = [45 137 60 22];
            app.anphaSpinnerLabel.Text = 'anpha(degree))';

            % Create anphaSpinner
            app.anphaSpinner = uispinner(app.inputPanel);
            app.anphaSpinner.Step = 0.5;
            app.anphaSpinner.Limits = [-20 20];
            app.anphaSpinner.Position = [120 137 100 22];
            app.anphaSpinner.Value = 10;

            % Create lengmSpinnerLabel
            app.lengmSpinnerLabel = uilabel(app.inputPanel);
            app.lengmSpinnerLabel.HorizontalAlignment = 'right';
            app.lengmSpinnerLabel.Position = [59 102 46 22];
            app.lengmSpinnerLabel.Text = 'leng(m)';

            % Create lengmSpinner
            app.lengmSpinner = uispinner(app.inputPanel);
            app.lengmSpinner.Step = 0.5;
            app.lengmSpinner.Limits = [2 6];
            app.lengmSpinner.Position = [120 102 100 22];
            app.lengmSpinner.Value = 2;

            % Create masskgSpinnerLabel
            app.masskgSpinnerLabel = uilabel(app.inputPanel);
            app.masskgSpinnerLabel.HorizontalAlignment = 'right';
            app.masskgSpinnerLabel.Position = [50 67 55 22];
            app.masskgSpinnerLabel.Text = 'mass(kg)';

            % Create masskgSpinner
            app.masskgSpinner = uispinner(app.inputPanel);
            app.masskgSpinner.Step = 0.3;
            app.masskgSpinner.Limits = [0 3];
            app.masskgSpinner.Position = [120 67 100 22];
            app.masskgSpinner.Value = 0.9;

            % Create grapButton
            app.grapButton = uibutton(app.inputPanel, 'push');
            app.grapButton.ButtonPushedFcn = createCallbackFcn(app, @grapButtonPushed, true);
            app.grapButton.Position = [87 38 100 22];
            app.grapButton.Text = 'graph';

            % Create animationButton
            app.animationButton = uibutton(app.inputPanel, 'push');
            app.animationButton.ButtonPushedFcn = createCallbackFcn(app, @animationButtonPushed, true);
            app.animationButton.Position = [85 9 100 22];
            app.animationButton.Text = 'animation';

            % Create outputPanel
            app.outputPanel = uipanel(app.thinghiemTab);
            app.outputPanel.Title = 'output';
            app.outputPanel.Position = [677 9 260 221];

            % Create timeEditFieldLabel
            app.timeEditFieldLabel = uilabel(app.outputPanel);
            app.timeEditFieldLabel.HorizontalAlignment = 'right';
            app.timeEditFieldLabel.Position = [74 164 28 22];
            app.timeEditFieldLabel.Text = 'time';

            % Create timeEditField
            app.timeEditField = uieditfield(app.outputPanel, 'numeric');
            app.timeEditField.Position = [117 164 100 22];

            % Create Button
            app.Button = uibutton(app.outputPanel, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [91 131 100 22];

            % Create xEditFieldLabel
            app.xEditFieldLabel = uilabel(app.outputPanel);
            app.xEditFieldLabel.HorizontalAlignment = 'right';
            app.xEditFieldLabel.Position = [92 99 25 22];
            app.xEditFieldLabel.Text = 'x';

            % Create xEditField
            app.xEditField = uieditfield(app.outputPanel, 'numeric');
            app.xEditField.Position = [132 99 100 22];

            % Create aEditFieldLabel
            app.aEditFieldLabel = uilabel(app.outputPanel);
            app.aEditFieldLabel.HorizontalAlignment = 'right';
            app.aEditFieldLabel.Position = [94 28 25 22];
            app.aEditFieldLabel.Text = 'a';

            % Create aEditField
            app.aEditField = uieditfield(app.outputPanel, 'numeric');
            app.aEditField.Position = [134 28 100 22];

            % Create vEditFieldLabel
            app.vEditFieldLabel = uilabel(app.outputPanel);
            app.vEditFieldLabel.HorizontalAlignment = 'right';
            app.vEditFieldLabel.Position = [94 61 25 22];
            app.vEditFieldLabel.Text = 'v';

            % Create vEditField
            app.vEditField = uieditfield(app.outputPanel, 'numeric');
            app.vEditField.Position = [133 61 100 22];

            % Create selectPanel
            app.selectPanel = uipanel(app.thinghiemTab);
            app.selectPanel.Title = 'select';
            app.selectPanel.Position = [677 517 260 198];

            % Create resetButton
            app.resetButton = uibutton(app.selectPanel, 'push');
            app.resetButton.ButtonPushedFcn = createCallbackFcn(app, @resetButtonPushed, true);
            app.resetButton.Position = [96 135 100 22];
            app.resetButton.Text = 'reset';

            % Create selectDropDownLabel
            app.selectDropDownLabel = uilabel(app.selectPanel);
            app.selectDropDownLabel.HorizontalAlignment = 'right';
            app.selectDropDownLabel.Position = [62 34 37 22];
            app.selectDropDownLabel.Text = 'select';

            % Create selectDropDown
            app.selectDropDown = uidropdown(app.selectPanel);
            app.selectDropDown.Items = {'x(t)', 'v(t)'};
            app.selectDropDown.ValueChangedFcn = createCallbackFcn(app, @selectDropDownValueChanged, true);
            app.selectDropDown.Position = [114 34 100 22];
            app.selectDropDown.Value = 'x(t)';

            % Create gridSwitchLabel
            app.gridSwitchLabel = uilabel(app.selectPanel);
            app.gridSwitchLabel.HorizontalAlignment = 'center';
            app.gridSwitchLabel.Position = [132 59 26 22];
            app.gridSwitchLabel.Text = 'grid';

            % Create gridSwitch
            app.gridSwitch = uiswitch(app.selectPanel, 'slider');
            app.gridSwitch.ValueChangedFcn = createCallbackFcn(app, @gridSwitchValueChanged, true);
            app.gridSwitch.Position = [121 96 45 20];

            % Create huongdanTab
            app.huongdanTab = uitab(app.TabGroup);
            app.huongdanTab.Title = 'instruction';

            % Create HngdnsdngLabel
            app.HngdnsdngLabel = uilabel(app.huongdanTab);
            app.HngdnsdngLabel.Position = [34 674 128 22];
            app.HngdnsdngLabel.Text = '1) Instruction';

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.huongdanTab);
            title(app.UIAxes3, 'Title')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            app.UIAxes3.Position = [23 473 304 185];

            % Create thbiudinmiquanhgiathigianvvntcgiathigianvlidaongLabel_2
            app.thbiudinmiquanhgiathigianvvntcgiathigianvlidaongLabel_2 = uilabel(app.huongdanTab);
            app.thbiudinmiquanhgiathigianvvntcgiathigianvlidaongLabel_2.Position = [20 437 485 22];
            app.thbiudinmiquanhgiathigianvvntcgiathigianvlidaongLabel_2.Text = 'The graph representing the relationship between time and velocity, between time and displacement  ';

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.huongdanTab);
            title(app.UIAxes4, 'Title')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            app.UIAxes4.Position = [20 206 307 217];

            % Create thmtsgiaongcaconlcLabel
            app.thmtsgiaongcaconlcLabel = uilabel(app.huongdanTab);
            app.thmtsgiaongcaconlcLabel.Position = [23 163 209 22];
            app.thmtsgiaongcaconlcLabel.Text = 'The graph describing oscillation of the pendulum';

            % Create vomsvntcbanucaconlcLabel
            app.vomsvntcbanucaconlcLabel = uilabel(app.huongdanTab);
            app.vomsvntcbanucaconlcLabel.Position = [592 653 203 21];
            app.vomsvntcbanucaconlcLabel.Text = 'vo(m/s): initial velocity of pendulum';

            % Create kNSMhsLabel
            app.kNSMhsLabel = uilabel(app.huongdanTab);
            app.kNSMhsLabel.Position = [592 619 89 21];
            app.kNSMhsLabel.Text = 'k(N.S/M): coefficient';

            % Create anphagcnghingcaconlcsovitrcthngngLabel
            app.anphagcnghingcaconlcsovitrcthngngLabel = uilabel(app.huongdanTab);
            app.anphagcnghingcaconlcsovitrcthngngLabel.Position = [592 586 329 34];
            app.anphagcnghingcaconlcsovitrcthngngLabel.Text = 'anpha(degree): angle between string of pendulum and vertical line';

            % Create lengmchiudicadyLabel
            app.lengmchiudicadyLabel = uilabel(app.huongdanTab);
            app.lengmchiudicadyLabel.Position = [592 560 153 22];
            app.lengmchiudicadyLabel.Text = 'leng(m) : length of string ';

            % Create masskgkhilngcaconlcLabel_2
            app.masskgkhilngcaconlcLabel_2 = uilabel(app.huongdanTab);
            app.masskgkhilngcaconlcLabel_2.Position = [592 524 182 22];
            app.masskgkhilngcaconlcLabel_2.Text = 'mass(kg): mass of pendulum';

            % Create g98ms2Label_2
            app.g98ms2Label_2 = uilabel(app.huongdanTab);
            app.g98ms2Label_2.Position = [592 484 78 22];
            app.g98ms2Label_2.Text = 'g=9.8 (m/s^2)';

            % Create resetButton_2
            app.resetButton_2 = uibutton(app.huongdanTab, 'push');
            app.resetButton_2.Position = [428 401 100 22];
            app.resetButton_2.Text = 'reset';

            % Create graphButton
            app.graphButton = uibutton(app.huongdanTab, 'push');
            app.graphButton.Position = [428 352 100 22];
            app.graphButton.Text = 'graph';

            % Create Button_2
            app.Button_2 = uibutton(app.huongdanTab, 'push');
            app.Button_2.Position = [676 401 100 22];

            % Create animationButton_2
            app.animationButton_2 = uibutton(app.huongdanTab, 'push');
            app.animationButton_2.Position = [676 352 100 22];
            app.animationButton_2.Text = 'animation';

            % Create chylichngtrnhLabel
            app.chylichngtrnhLabel = uilabel(app.huongdanTab);
            app.chylichngtrnhLabel.Position = [536 401 122 22];
            app.chylichngtrnhLabel.Text = 'run the program again ';

            % Create ntvthLabel
            app.ntvthLabel = uilabel(app.huongdanTab);
            app.ntvthLabel.Position = [536 352 74 22];
            app.ntvthLabel.Text = 'drawing the graph ';

            % Create ntchychngtrnhraccthngsLabel
            app.ntchychngtrnhraccthngsLabel = uilabel(app.huongdanTab);
            app.ntchychngtrnhraccthngsLabel.Position = [782 401 210 22];
            app.ntchychngtrnhraccthngsLabel.Text = 'output';

            % Create ntvconlcmtgiaongLabel
            app.ntvconlcmtgiaongLabel = uilabel(app.huongdanTab);
            app.ntvconlcmtgiaongLabel.Position = [781 352 169 22];
            app.ntvconlcmtgiaongLabel.Text = 'drawing the pendulum describing oscillation';

            % Create SwitchLabel
            app.SwitchLabel = uilabel(app.huongdanTab);
            app.SwitchLabel.HorizontalAlignment = 'center';
            app.SwitchLabel.Position = [453 264 41 22];
            app.SwitchLabel.Text = 'Switch';

            % Create Switch
            app.Switch = uiswitch(app.huongdanTab, 'slider');
            app.Switch.Position = [450 301 45 20];

            % Create bttttacathLabel
            app.bttttacathLabel = uilabel(app.huongdanTab);
            app.bttttacathLabel.Position = [536 289 138 22];
            app.bttttacathLabel.Text = ' turn on/off the grid of the graph ';

            % Create selectDropDown_2Label
            app.selectDropDown_2Label = uilabel(app.huongdanTab);
            app.selectDropDown_2Label.HorizontalAlignment = 'right';
            app.selectDropDown_2Label.Position = [365 221 37 22];
            app.selectDropDown_2Label.Text = 'select';

            % Create selectDropDown_2
            app.selectDropDown_2 = uidropdown(app.huongdanTab);
            app.selectDropDown_2.Items = {'v(t)', 'x(t) '};
            app.selectDropDown_2.Position = [417 221 100 22];
            app.selectDropDown_2.Value = 'v(t)';

            % Create chnmiquanhchoththigianvvntchocthigianvligiaongLabel
            app.chnmiquanhchoththigianvvntchocthigianvligiaongLabel = uilabel(app.huongdanTab);
            app.chnmiquanhchoththigianvvntchocthigianvligiaongLabel.Position = [526 221 459 22];
            app.chnmiquanhchoththigianvvntchocthigianvligiaongLabel.Text = 'choose relationship type for the graph : between time and velocity / between time and displacement of pendulum';

            % Create timethigianconlcgiaongLabel
            app.timethigianconlcgiaongLabel = uilabel(app.huongdanTab);
            app.timethigianconlcgiaongLabel.Position = [429 173 182 22];
            app.timethigianconlcgiaongLabel.Text = 'time: the time that the pendulum oscillates ';

            % Create liEditFieldLabel
            app.liEditFieldLabel = uilabel(app.huongdanTab);
            app.liEditFieldLabel.HorizontalAlignment = 'right';
            app.liEditFieldLabel.Position = [344 119 28 22];
            app.liEditFieldLabel.Text = 'displacement';

            % Create liEditField
            app.liEditField = uieditfield(app.huongdanTab, 'text');
            app.liEditField.Position = [387 119 100 22];

            % Create vntcEditFieldLabel
            app.vntcEditFieldLabel = uilabel(app.huongdanTab);
            app.vntcEditFieldLabel.HorizontalAlignment = 'right';
            app.vntcEditFieldLabel.Position = [547 119 44 22];
            app.vntcEditFieldLabel.Text = 'velocity';

            % Create vntcEditField
            app.vntcEditField = uieditfield(app.huongdanTab, 'text');
            app.vntcEditField.Position = [606 119 100 22];

            % Create giatcEditFieldLabel
            app.giatcEditFieldLabel = uilabel(app.huongdanTab);
            app.giatcEditFieldLabel.HorizontalAlignment = 'right';
            app.giatcEditFieldLabel.Position = [784 119 41 22];
            app.giatcEditFieldLabel.Text = 'acceleration';

            % Create giatcEditField
            app.giatcEditField = uieditfield(app.huongdanTab, 'text');
            app.giatcEditField.Position = [840 119 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = oscillation

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end